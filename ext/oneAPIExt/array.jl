
function JACC.zeros(::oneAPITag, ::Type{T}, dims...) where {T}
    return oneAPI.zeros(T, dims...)
end

function JACC.ones(::oneAPITag, ::Type{T}, dims...) where {T}
    return oneAPI.ones(T, dims...)
end

function JACC.fill(::oneAPITag, value, dims...)
    return oneAPI.fill(value, dims...)
end
