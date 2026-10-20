module Async

import Base: Callable
using JACC, AMDGPU
using AMDGPUExt: AMDGPUBackend, AMDGPUTag

@inline ndevices() = length(AMDGPU.devices())
@inline get_device_id(id) = ((id - 1) % ndevices()) + 1
@inline set_relative_device!(id) = AMDGPU.device_id!(get_device_id(id))

JACC.Async.ndev(::AMDGPUTag) = ndevices()

function JACC.Async.zeros(::AMDGPUTag, T, id, dims...)
    set_relative_device!(id)
    ret = AMDGPU.zeros(T, dims...)
    AMDGPU.device_id!(1)
    return ret
end

function JACC.Async.ones(::AMDGPUTag, T, id, dims...)
    set_relative_device!(id)
    ret = AMDGPU.ones(T, dims...)
    AMDGPU.device_id!(1)
    return ret
end

function JACC.Async.fill(::AMDGPUTag, id, value, dims...)
    set_relative_device!(id)
    ret = AMDGPU.fill(value, dims...)
    AMDGPU.device_id!(1)
    return ret
end

function JACC.Async.synchronize(::AMDGPUTag)
    ndev = ndevices()
    for i in 1:ndev
        AMDGPU.device_id!(i)
        AMDGPU.synchronize()
    end
    AMDGPU.device_id!(1)
end

function JACC.Async.synchronize(::AMDGPUTag, id::Integer)
    set_relative_device!(id)
    AMDGPU.synchronize()
    AMDGPU.device_id!(1)
end

function JACC.Async.array(::AMDGPUTag, id::Integer, x::AbstractArray)
    set_relative_device!(id)
    ret = JACC.array(AMDGPUBackend, x)
    AMDGPU.device_id!(1)
    return ret
end

function JACC.Async.parallel_for(
        ::AMDGPUTag, id::Integer, dims::JACC.IDims, f::Callable, x...)
    set_relative_device!(id)
    JACC.parallel_for(JACC.LaunchSpec{AMDGPUBackend}(; sync = false), dims, f, x...)
    AMDGPU.device_id!(1)
end

function JACC.Async.parallel_reduce(::AMDGPUTag, id::Integer,
        dims::JACC.IDims, op::Callable, f::Callable, x...; init)
    set_relative_device!(id)
    reducer = JACC.reducer(; backend = AMDGPUBackend, range = dims, op = op,
        init = init, sync = false)
    reducer(f, x...)
    ret = reducer.workspace.ret
    AMDGPU.device_id!(1)
    return ret
end

end # module Async
