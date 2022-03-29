using MassConversion
using Test

@testset "MassConversion.jl" begin
    # Write your tests here.

    @testset "Data Structure Tests" begin
        traj1 = ones(10, 1000, 250)

        mn = MassConversion.calc_mean(traj1)
        @test size(mn) == (10, 1000)
        @test all(mn .≈ 1)
        
        mn2 = MassConversion.calc_mean_total(mn, mn)
        @test size(mn2) == (10, 1000)
        @test all(mn2 .≈ 2)

        vr = MassConversion.calc_var(traj1, mn)
        @test size(vr) == (10, 1000)

        model = MassConversion.MCMOutput(traj1)
        @test size(model.trajectories_continuum) == (5, 1000, 250)
        @test size(model.trajectories_discrete)  == (5, 1000, 250)
        @test size(model.mean_discrete)          == (1000,5) 
        @test size(model.mean_continuum)         == (1000,5) 
        @test size(model.mean_total)             == (1000,5) 
        @test size(model.var_total)              == (1000,5) 

        @test all(model.trajectories_continuum .== 1.0)
        @test all(model.trajectories_discrete .== 1.0)
        @test all(model.mean_continuum .== 1.0)
        @test all(model.mean_discrete .== 1.0)
        @test all(model.mean_total .== 2.0)
    end

    @testset "Interval tests" begin
        int1 = Interval([1,2])
        int2 = Interval([0.5,2.5])
        int3 = Interval([0, 1.5])
        int4 = Interval([1.5, 2.5])
        int5 = Interval([1.1, 1.9])
        int6 = Interval([4, 5])
        @test 1.5 ∈ int1
        @test 3 ∉ int1
        uint1 = int1 ∪ int2
        @test 0.8 ∈ uint1
        @test 0 ∉ uint1
    end
end

#   @testset "Model setup tests" begin
#       model = Model()
#       model <= Species("A", 100)
#       model <= Species("B", 10)
#       model <= Species("EE", 9)
#
#       species = get_init(model)
#       @test species["A"] == 100
#       @test species["B"] == 10
#       @test species["EE"] == 9
#       @test_throws MassConversion.ModelSpecError Species("A+A", 0)
#       @test_throws MassConversion.ModelSpecError Species("A + 33", 4)
#       @test_throws MassConversion.ModelSpecError model <= Species("A", 10)
#    end