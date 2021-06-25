function [t,mu] = test_lyapunov(N, g, tmax)
[h0, J_mat] = rnn_init(N);
v0 = 2*rand(1,N)-1; v0 = v0 / sqrt(sum(v0.^2)); 
v0 = ones(1,N);  v0 = v0 / sqrt(sum(v0.^2)); 
[t,S] = ode23(@(t,S) test_sys(S, g, J_mat), [0,tmax], [h0', v0]);

v = S(:,N+1:end);
mag_v = sqrt(sum(v.^2,2));
mu = log(mag_v) ./ t;
end

function dS_dt = test_sys(S,g,J_mat)
N = size(J_mat,1); 
h = S(1:N); 
v = S(N+1:end); 

dh_dt = rnn_sys(h, g, J_mat); 

Df = rnn_jacobian(h,g,J_mat);
dv_dt = Df * v; 

dS_dt = [dh_dt; dv_dt]; 
end
