run start_up.m

%% Define parameters + main variables
N = 200;
g_vec = unique([0.01, 0.1:0.1:1, 1:10]);
n_gvars = length(g_vec);
n_inits = 1;

%%
N = 500; 
g = 1; 
tmax = 200; 
% tic
% [t,mu] = test_lyapunov(N, g, tmax);
% toc
% figure; plot(t, mu)
%%

tmax = 500;  
max_mu = g_vec;
parfor i = 1:length(g_vec)
    g=g_vec(i); 
[t,mu] = test_lyapunov(N, g, tmax);
mu = mu(ceil(end/2):end); 
max_mu(i) = mu(max(abs(mu)) == abs(mu)); 
end
%%

N = 500; 
g = 1.2; 
tmax = 400; 
[h0, J_mat] = rnn_init(N);
tic
% [t_sim,h_stim] = ode23(@(t,h) rnn_sys(h, g, J_mat), [0,tmax], h0');
[t_lyapunov, lyapunov_exp]=lyapunov(N,@(t,X) rnn_eqs_lyapunov(X, g, J_mat),@ode23,...
    0,200,tmax,h0',0);
toc
% 
% tic
%  [Texp,Lexp]=lyapunov_opt(N,@(t,X) rnn_eqs_lyapunov(X, g, J_mat),@ode23,...
%     0,1,tmax,h0');
% toc