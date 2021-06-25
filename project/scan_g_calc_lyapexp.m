run start_up.m

%% Define parameters + main variables
N = 200;
g_vec = unique([0.01, 0.1:0.1:1, 1:10]);
n_gvars = length(g_vec);
n_inits = 10;
tmax = 100;
dt_lyapunov = 0.5;

%% Run and save  

results = cell(n_gvars, 1);  
ppm = ParforProgMon('Running', n_gvars*n_inits); 

t0 = tic; 
for ig = 1:n_gvars
    t1 = tic; 
    g = g_vec(ig); 
    tmp_res = cell(n_inits,1); 
    parfor ni = 1:n_inits
        tmp_struct = struct(); 
        [h0, J_mat] = rnn_init(N);
        [t_sim,h_stim] = ode23(@(t,h) rnn_sys(h, g, J_mat), [0,tmax], h0');
        [t_lyapunov, lyapunov_exp]=lyapunov(N,@(t,X) rnn_eqs_lyapunov(X, g, J_mat),@ode23,...
            0,dt_lyapunov,tmax,h0',0);
        tmp_struct.h0 = h0; 
        tmp_struct.J_mat = J_mat; 
        tmp_struct.sim.t = t_sim; 
        tmp_struct.sim.h = h_stim; 
        tmp_struct.lyapunov.t = t_lyapunov; 
        tmp_struct.lyapunov.lambdas = lyapunov_exp; 
        tmp_res{ni} = tmp_struct; 
        ppm.increment(); %#ok
    end
    results{ig} = horzcat(tmp_res{:});
    fprintf('\t + G (%d/%d) - took %.2f minutes.\n', ig, n_gvars, toc(t1)/60); 
end

fprintf('Finished, took %.2f minutes.\n', toc(t0)/60);  
save('data/rnn_sim_lyapunov.mat', ...
    'N', 'g_vec', 'g_vec', 'n_inits', 'n_gvars', 'tmax', 'dt_lyapunov', 'results');
