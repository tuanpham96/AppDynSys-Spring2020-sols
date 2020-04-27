%% Exploring and test sim for pendulum
s0 = [0.00001,0.00002];
alpha = 120;300; 97.9592; alpha_vec(17); 97.96 ; 220;
omega = 10; 80; 5.0408;omega_vec(3); 5;60; 20; 10*pi;
beta = 10;

T = 2*pi/omega;

tspan = [0, 10*T];
dt_max = min(T/1000, 1e-3);

tic
    options = odeset('InitialStep',dt_max/10,'MaxStep',dt_max);
[t,s] = ode23(@(t,s) dpendulum_withdampen(t, s, alpha, omega, beta), tspan, s0, options);
toc

figure;
subplot(121); hold on;
plot(t, s(:,1), 'displayname', 'x(t)')
plot(t, s(:,2), 'displayname', 'y(t)')
xline(T, '--k')
legend('show');
subplot(122); hold on;
plot(s(:,1), s(:,2), '-k');


[~, ~, ~, mus] = vibrate_my_dampened_pendulum(nan, alpha, omega, beta);
mus
%% Test calculation of monodromy matrix and floqet multipliers
% note: instead of doing this, could have easily used 2 initial conditions
% of X as an identity matrix = \Phi(0), M = \Phi(T)
[~, loc_1T] = min(abs(t - 1*T));
s_1T = s(loc_1T, :)';

[~, loc_2T] = min(abs(t - 2*T));
s_2T = s(loc_2T, :)';

[~, loc_3T] = min(abs(t - 3*T));
s_3T = s(loc_3T, :)';

M = [s_1T,s_2T,s_3T] / [s0',s_1T,s_2T];

eig(M)

M = [s_1T,s_2T] / [s0',s_1T];

mus = eig(M)
abs(mus(1))
abs(mus(2))
