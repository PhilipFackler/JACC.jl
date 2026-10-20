
JACC.zeros(::Type{ThreadsBackend}, T, dims...) = Base.zeros(T, dims...)
JACC.ones(::Type{ThreadsBackend}, T, dims...) = Base.ones(T, dims...)
JACC.fill(::Type{ThreadsBackend}, value, dims...) = Base.fill(value, dims...)
