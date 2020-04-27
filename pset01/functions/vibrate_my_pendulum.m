function [mus, t, s] = vibrate_my_pendulum(s0, alpha, omega, max_num_T)
if ~exist('max_num_T', 'var'), max_num_T = 3.1; end

T = 2*pi/omega; 

tspan = [0, max_num_T*T];
dt_max = T/1000;

options = odeset('InitialStep',dt_max/10,'MaxStep',dt_max); 

[t,s] = ode23(@(t,s) dpendulum(t, s, alpha, omega), tspan, s0, options);

[~, loc_1T] = min(abs(t - 1*T)); 
s_1T = s(loc_1T, :)'; 

[~, loc_2T] = min(abs(t - 2*T)); 
s_2T = s(loc_2T, :)';

M = [s_1T,s_2T] / [s0',s_1T]; 

if ~isempty(find(isnan(M(:)) | isinf(M(:)), 1))
    mus = nan(2,1);
else
    mus = eig(M);
end

end