using Revise
using Plots
using MassConversion
pgfplotsx()

dir = "decay2";

ode = load_raw(joinpath("/home/jkynaston/git/MassConversion.jl/examples/alt-exp/dat/", dir*"-ode"));
mcm = load_raw(joinpath("/home/jkynaston/git/MassConversion.jl/examples/alt-exp/dat/", dir*"-mcm"));

ode_full = sum(ode);
mcm_full = sum(mcm);

p = plot(dpi=600)
plot(p,mcm_full)

function f(t)
    if t ≤ 0
        1000.0
    elseif 0 < t ≤ 5.5
        1000.0*exp(-t)
    elseif t ≥ 15/2
        1082.0849986238989 * exp(-t+7.5)
    else
        200*t - 417.9150013761012
    end
end;

t = ode_full.t_range;
ode_dat = ode_full.C;
mcm_dat = mcm_full.D .+ mcm_full.C;
tru_dat = f.(t);

rel_err_mcm = zeros(t.len, length(mcm))

rel_err_ode = ((ode_dat .- tru_dat) ./ tru_dat);
rel_err_mcm = ((mcm_dat .- tru_dat) ./ tru_dat);

#for i in 1:length(mcm)
#    rel_err_mcm[:,i] = (((mcm[i].C .+ mcm[i].D) .- tru_dat) ./ tru_dat);
#end

p = plot(t, rel_err_ode;label="ode",dpi=600);
plot(t[1:100:end], rel_err_mcm[1:100:end,:];label="mcm",dpi=600)
p
vline!([1.38])