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

@testset "array_storage_preference" begin
    using Metal
    using Suppressor
    N = 10
    h = ones(Float32, N)
    x = JACC.array(h)
    @test typeof(x) == MtlArray{Float32, 1, Metal.PrivateStorage}
    try
        @suppress JACC.set_backend("Metal"; storage = :shared)
        @test load_preference(JACC, "metal_array_storage") == "shared"
        xs = JACC.array(h)
        @test typeof(xs) == MtlArray{Float32, 1, Metal.SharedStorage}
        @test Metal.is_shared(xs)
        @test Array(xs) == h
        h2 = ones(Float32, N, N)
        xs2 = JACC.array(h2)
        @test typeof(xs2) == MtlArray{Float32, 2, Metal.SharedStorage}
    finally
        @suppress JACC.set_backend("Metal"; storage = :private)
    end
    @test_throws ArgumentError JACC.set_backend("Metal"; storage = :bogus)
    @test_throws ArgumentError JACC.set_backend("CUDA"; storage = :shared)
end

include("preferences.jl")

@testset "preferences" begin
    test_preferences(:Metal)
end
