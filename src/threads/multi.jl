module Multi

import JACC
import JACC.ThreadsImpl: ThreadsBackend, ThreadsTag

JACC.Multi.ndev(::ThreadsTag) = 1
JACC.Multi.synchronize(::ThreadsTag) = nothing
JACC.Multi.device_id(::ThreadsTag, x) = 1

JACC.Multi.part_length(::ThreadsTag, x) = size(x)[end]

struct MultiArray{T, N} <: JACC.Multi.AbstractMultiArray
    a::Base.Array{T, N}
end
@inline Base.size(a::MultiArray) = size(a.a)
@inline Base.length(a::MultiArray) = length(a.a)
@inline Base.getindex(a::MultiArray, i...) = getindex(a.a, i...)
@inline Base.setindex!(a::MultiArray, v, i...) = setindex!(a.a, v, i...)

JACC.to_host(x::MultiArray) = convert(Base.Array, x)
Base.convert(::Type{Base.Array}, x::MultiArray{T, N}) where {T, N} = x.a

function JACC.Multi.array(
        ::ThreadsTag, x::Base.Array{T, N}; ghost_dims) where {T, N}
    return MultiArray{T, N}(x)
end
JACC.Multi.multi_array_type(::ThreadsTag) = MultiArray

JACC.Multi.ghost_shift(::ThreadsTag, idx, arr) = idx

JACC.Multi.sync_ghost_elems!(::ThreadsTag, arr) = nothing

function JACC.Multi.copy!(::ThreadsTag, x::MultiArray, y::MultiArray)
    copy!(x.a, y.a)
end

function JACC.Multi.parallel_for(
        f, ::ThreadsTag, N::Integer, x...; sync = false)
    return JACC.parallel_for(f, ThreadsBackend, N, x...)
end

function JACC.Multi.parallel_for(
        f, ::ThreadsTag, (M, N)::NTuple{2, Integer}, x...; sync = false)
    return JACC.parallel_for(f, ThreadsBackend, (M, N), x...)
end

function JACC.Multi.parallel_reduce(
        f, ::ThreadsTag, N::Integer, x...; op, init)
    return JACC.parallel_reduce(f, ThreadsBackend, N, x...; op = op,
        init = init)
end

function JACC.Multi.parallel_reduce(
        f, ::ThreadsTag, (M, N)::NTuple{2, Integer}, x...; op, init)
    return JACC.parallel_reduce(f, ThreadsBackend, (M, N), x...; op = op,
        init = init)
end

end
