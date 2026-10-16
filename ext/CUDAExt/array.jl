
function JACC.zeros(::CUDATag, T, dims...)
    return CUDA.zeros(T, dims...)
end

function JACC.ones(::CUDATag, T, dims...)
    return CUDA.ones(T, dims...)
end

function JACC.fill(::CUDATag, value, dims...)
    CUDA.fill(value, dims...)
end
