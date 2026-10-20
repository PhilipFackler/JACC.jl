module Multi

import Base.Callable
import JACC
import JACC.ThreadsImpl: ThreadsBackend

function JACC.Multi.ndev(::Type{ThreadsBackend})
    return 1
end

function JACC.Multi.device_id(::Type{ThreadsBackend}, x)
    return 1
end

function JACC.Multi.part_length(::Type{ThreadsBackend}, x)
    return size(x)[end]
end

function JACC.Multi.array(::Type{ThreadsBackend}, x::Base.Array; ghost_dims)
    return x
end

JACC.Multi.multi_array_type(::Type{ThreadsBackend}) = Base.Array

function JACC.Multi.ghost_shift(::Type{ThreadsBackend}, idx, arr)
    return idx
end

function JACC.Multi.sync_ghost_elems!(::Type{ThreadsBackend}, arr)
end

function JACC.Multi.copy!(::Type{ThreadsBackend}, x, y)
    copy!(x, y)
end

function JACC.Multi.parallel_for(
        ::Type{ThreadsBackend}, N::Integer, f::Callable, x...)
    return JACC.parallel_for(f, ThreadsBackend, N, x...)
end

function JACC.Multi.parallel_for(
        ::Type{ThreadsBackend}, (M, N)::NTuple{2, Integer}, f::Callable, x...)
    return JACC.parallel_for(f, ThreadsBackend, (M, N), x...)
end

function JACC.Multi.parallel_reduce(
        ::Type{ThreadsBackend}, N::Integer, f::Callable, x...)
    return JACC.parallel_reduce(f, ThreadsBackend, N, x...; op = +,
        init = 0.0)
end

function JACC.Multi.parallel_reduce(
        ::Type{ThreadsBackend}, (M, N)::NTuple{2, Integer}, f::Callable, x...)
    return JACC.parallel_reduce(f, ThreadsBackend, (M, N), x...; op = +,
        init = 0.0)
end

end
