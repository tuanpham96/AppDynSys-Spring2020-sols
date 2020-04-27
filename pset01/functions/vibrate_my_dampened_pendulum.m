function [t, s, sT, mus] = vibrate_my_dampened_pendulum(s0, alpha, omega, beta, max_num_T)
if ~exist('max_num_T', 'var'), max_num_T = 1.1; end

if isnan(s0) 
    [~, ~, sT_1] = vibrate_my_dampened_pendulum([1, 0], alpha, omega, beta, max_num_T);
    [~, ~, sT_2] = vibrate_my_dampened_pendulum([0, 1], alpha, omega, beta, max_num_T);
    M = [sT_1, sT_2]; 
    t = []; s = []; sT = []; 
    mus = eig(M); 
    return;
end
T = 2*pi/omega; 

tspan = [0, max_num_T*T];
dt_max = T/1000;

options = odeset('InitialStep',dt_max/10,'MaxStep',dt_max); 

[t,s] = ode23(@(t,s) dpendulum_withdampen(t, s, alpha, omega, beta), tspan, s0, options);

[~, loc_1T] = min(abs(t - 1*T)); 
sT = s(loc_1T, :)'; 
mus = nan;
end