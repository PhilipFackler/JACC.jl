import Metal

@testset "TestBackend" begin
    @test JACC.backend == "metal"
    @test JACC.default_backend() == JACC.get_backend(JACC.Backend.metal)
end

@testset "zeros_type" begin
    using Metal
    N = 10
    x = JACC.zeros(Float32, N)
    @test typeof(x) == MtlArray{Float32, 1, Metal.PrivateStorage}
    @test eltype(x) == Float32
end

@testset "ones_type" begin
    using Metal
    N = 10
    x = JACC.ones(Float32, N)
    @test typeof(x) == MtlArray{Float32, 1, Metal.PrivateStorage}
    @test eltype(x) == Float32
end

@testset "array_storage" begin
    using Metal
    N = 10
    h = ones(Float32, N)
    x = JACC.array(h)
    @test typeof(x) == MtlArray{Float32, 1, Metal.PrivateStorage}
    xs = JACC.array(h; storage = :shared)
    @test typeof(xs) == MtlArray{Float32, 1, Metal.SharedStorage}
    @test Metal.is_shared(xs)
    @test Array(xs) == h
    xp = JACC.array(h; storage = :private)
    @test typeof(xp) == MtlArray{Float32, 1, Metal.PrivateStorage}
    @test Array(xp) == h
    h2 = ones(Float32, N, N)
    xs2 = JACC.array(h2; storage = :shared)
    @test typeof(xs2) == MtlArray{Float32, 2, Metal.SharedStorage}
    @test_throws ArgumentError JACC.array(h; storage = :bogus)
end

include("preferences.jl")

@testset "preferences" begin
    test_preferences(:Metal)
end
