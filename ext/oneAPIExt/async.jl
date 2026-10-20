module Async

import Base: Callable
using JACC, oneAPI
using oneAPIExt: oneAPITag

@inline ndevices() = length(oneAPI.devices())
@inline get_device_id(id) = ((id - 1) % ndevices()) + 1
@inline set_relative_device!(id) = oneAPI.device!(get_device_id(id))

JACC.Async.ndev(::oneAPITag) = ndevices()

function JACC.Async.zeros(::oneAPITag, T, id, dims...)
    set_relative_device!(id)
    ret = oneAPI.zeros(T, dims...)
    oneAPI.device!(1)
    return ret
end

function JACC.Async.ones(::oneAPITag, T, id, dims...)
    set_relative_device!(id)
    ret = oneAPI.ones(T, dims...)
    oneAPI.device!(1)
    return ret
end

function JACC.Async.fill(::oneAPITag, id, value, dims...)
    set_relative_device!(id)
    ret = oneAPI.fill(value, dims...)
    oneAPI.device!(1)
    return ret
end

function JACC.Async.synchronize(::oneAPITag)
    ndev = ndevices()
    for i in 1:ndev
        oneAPI.device!(i)
        oneAPI.synchronize()
    end
    oneAPI.device!(1)
end

function JACC.Async.synchronize(::oneAPITag, id::Integer)
    set_relative_device!(id)
    oneAPI.synchronize()
    oneAPI.device!(1)
end

function JACC.Async.array(::oneAPITag, id::Integer, x::AbstractArray)
    set_relative_device!(id)
    ret = JACC.array(oneAPIBackend, x)
    oneAPI.device!(1)
    return ret
end

function JACC.Async.parallel_for(
        ::oneAPITag, id::Integer, dims::JACC.IDims, f::Callable, x...)
    set_relative_device!(id)
    JACC.parallel_for(JACC.LaunchSpec{oneAPIBackend}(; sync = false), dims, f, x...)
    oneAPI.device!(1)
end

function JACC.Async.parallel_reduce(::oneAPITag, id::Integer,
        dims::JACC.IDims, op::Callable, f::Callable, x...; init)
    set_relative_device!(id)
    reducer = JACC.reducer(; backend = oneAPIBackend, range = dims, op = op,
        init = init, sync = false)
    reducer(f, x...)
    ret = reducer.workspace.ret
    oneAPI.device!(1)
    return ret
end

end # module Async
