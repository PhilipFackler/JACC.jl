
function JACC.zeros(::AMDGPUTag, T, dims...)
    return AMDGPU.zeros(T, dims...)
end

function JACC.ones(::AMDGPUTag, T, dims...)
    return AMDGPU.ones(T, dims...)
end

function JACC.fill(::AMDGPUTag, value, dims...)
    return AMDGPU.fill(value, dims...)
end
