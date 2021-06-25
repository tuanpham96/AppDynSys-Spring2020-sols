run start_up.m

%% Define parameters + main variables
N_vec = [100, 200, 300];
g_vec = unique([0.95:0.025:1, 1:0.25:2]);
n_gvars = length(g_vec);
n_nvars = length(N_vec); 
n_inits = 5;
tmax = 150;
dt_lyapunov = 0.5;

%% Run and save  

results = cell(n_nvars,n_gvars);  
ppm = ParforProgMon('Running', n_gvars*n_inits*n_nvars); 

t0 = tic; 
for i_g = 1:n_gvars
    for i_n = 1:n_nvars
        t1 = tic;
        N = N_vec(i_n);
        g = g_vec(i_g);
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
        results{i_n,i_g} = horzcat(tmp_res{:});
        fprintf('\t + N(%d/%d) and G (%d/%d) - took %.2f minutes.\n', i_n, n_nvars, i_g, n_gvars, toc(t1)/60);
    end
end

fprintf('Finished, took %.2f minutes.\n', toc(t0)/60);  
save('data/rnn_sim_lyapunov_finerscan.mat', ...
    'N_vec', 'g_vec', 'n_inits', 'n_nvars', 'n_gvars', 'tmax', 'dt_lyapunov', 'results');
