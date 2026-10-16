function JACC.zeros(::MetalTag, ::Type{T}, dims...) where {T}
    return Metal.zeros(T, dims...)
end

function JACC.ones(::MetalTag, ::Type{T}, dims...) where {T}
    return Metal.ones(T, dims...)
end

function JACC.fill(::MetalTag, value, dims...)
    return Metal.fill(value, dims...)
end
