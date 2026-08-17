module Multi

export ndev, device_id, synchronize
export AbstractMultiArray
export part_length, multi_array_type
export ghost_shift, sync_ghost_elems!

public parallel_for, parallel_reduce
public @parallel_for, @parallel_reduce

import JACC
import JACC._construct_call

function ndev()
    return ndev(JACC.default_backend_type())
end

synchronize() = synchronize(JACC.default_backend())

function part_length(x)
    return part_length(JACC.default_backend_type(), x)
end

function device_id(x)
    return device_id(JACC.default_backend_type(), x)
end

abstract type AbstractMultiArray end

function multi_array_type()
    return multi_array_type(JACC.default_backend_type())
end

function array(x::Base.Array; ghost_dims = 0)
    return array(JACC.default_backend_type(), x; ghost_dims = ghost_dims)
end

function ghost_shift(idx::Union{Integer, NTuple{2, Integer}}, arr)
    return ghost_shift(JACC.default_backend_type(), idx, arr)
end

function sync_ghost_elems!(arr)
    return sync_ghost_elems!(JACC.default_backend_type(), arr)
end

function copy!(dest, src)
    return copy!(JACC.default_backend_type(), dest, src)
end

@inline function parallel_for(f, dims::JACC.IDims, x...; kw...)
    parallel_for(f, JACC.default_backend_type(), dims, x...; kw...)
end

@inline function parallel_for(dims::JACC.IDims, f, x...; kw...)
    parallel_for(f, dims, x...; kw...)
end

@inline function parallel_for(f, range::AbstractRange, x...)
    # TODO
end

@inline function parallel_for(f, range::NTuple{N, AbstractRange}, x...) where {N}
    # TODO
end

@inline function parallel_for(; range::TR, f, args::Tuple, kw...) where {TR}
    parallel_for(f, range, args...; kw...)
end

macro parallel_for(args...)
    esc(_construct_call(JACC.Multi.parallel_for, [:range, :sync], args...))
end

@inline function parallel_reduce(f, dims::JACC.IDims, x...;
        type = nothing, op = +, init = nothing)
    _init = JACC._resolve_init_type(op, type, init)
    return parallel_reduce(
        f, JACC.default_backend_type(), dims, x...; op = op, init = _init)
end

@inline function parallel_reduce(dims::JACC.IDims, f, x...)
    return parallel_reduce(f, dims, x...)
end

@inline function parallel_reduce(f, range::AbstractRange, x...; kw...)
    # TODO
end

@inline function parallel_reduce(f, range::NTuple{N, AbstractRange}, x...; kw...) where {N}
    # TODO
end

@inline function parallel_reduce(; range::TR, f, args::Tuple, type = nothing,
        op = +, init = nothing, kw...) where {TR}
    return parallel_reduce(f, range, args...; type = type, op = op, init = init)
end

@inline function parallel_reduce(op, a::JACC.Multi.AbstractMultiArray;
        init = JACC.default_init(eltype(a), op))
    return parallel_reduce(
        JACC.elem_access, JACC.array_size(a), a; op = op, init = init)
end

@inline function parallel_reduce(a::JACC.Multi.AbstractMultiArray; kw...)
    return parallel_reduce(+, a, kw...)
end

macro parallel_reduce(args...)
    esc(_construct_call(JACC.Multi.parallel_reduce,
        [:range, :type, :op, :init], args...))
end

end # module Multi
