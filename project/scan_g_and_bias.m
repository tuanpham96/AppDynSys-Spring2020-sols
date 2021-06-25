run start_up.m

beta_vec = linspace(0,0.5,10);
sigma_beta_vec = linspace(0.001,0.6,100);
g_vec = linspace(0.5,2.5,100); 

n_betas = length(beta_vec);
n_sigbets = length(sigma_beta_vec);
n_gvars = length(g_vec); 

all_sign_lambdas = cell(n_betas,1); 
for ib = 1:n_betas    
    sign_lambdas = zeros(n_sigbets,n_gvars); 
    beta = beta_vec(ib);
    t0 = tic; 
    parfor isb = 1:n_sigbets
        sigma_beta = sigma_beta_vec(isb);
        
        lambda_integrateds = arrayfun(@(g) theo_max_lyapunov_with_bias(g,beta,sigma_beta), g_vec); 
        sign_lambdas(isb,:) = sign(lambda_integrateds);
    end
    all_sign_lambdas{ib} = sign_lambdas; 
    fprintf('Done with %d/%d. Elapsed %.2f minutes. \n', ib, n_betas, toc(t0)/60); 
end

save('data/lyapunov_gain_and_bias.mat', ...
    'beta_vec', 'sigma_beta_vec', 'g_vec', 'all_sign_lambdas', ...
    'n_betas', 'n_sigbets', 'n_gvars');
