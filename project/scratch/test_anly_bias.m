g_vec = [0.1,0.25,0.5,1,2,4,10];
beta_vec = [-1,0,1];
sigma_beta_vec = [0, 1, 2];

cmap = return_colorbrewer('Spectral', length(g_vec))*0.9;
V_vec = 0:0.01:5;

n_betas = length(beta_vec);
n_sigbets = length(sigma_beta_vec);


graphic_reset(15, ...
    'DefaultAxesMinorGridAlpha', 0.05, ...
    'DefaultAxesMinorGridLineStyle', '-', ...
    'DefaultTextInterpreter', 'latex', ...
    'DefaultLegendInterpreter', 'latex', ...
    'DefaultAxesLineWidth', 2, ...
    'DefaultLineLineWidth', 3, ...
    'DefaultAxesLabelFontSize', 1.25, ...
    'DefaultAxesTitleFontSize', 1.25);
figure; 
cnt_splt = 1; 
for ib = 1:n_betas
    for isb = 1:n_sigbets
        beta = beta_vec(ib);
        sigma_beta = sigma_beta_vec(isb);
        
        subplot(n_betas, n_sigbets, cnt_splt); hold on; cnt_splt = cnt_splt+1; 
        lgndobjs = arrayfun(@(g,c) plot(V_vec, local_field_var(g,V_vec, beta, sigma_beta), 'color', c{:}, ...
            'displayname', sprintf('g=%g',g)), g_vec, mat2colcell(cmap)');
        plot(V_vec, V_vec, ':k');
        title(sprintf('$\\beta = %g, \\sigma_{\\beta} = %g$', beta, sigma_beta)); 
        daspect([1,1,1]);
        if ib == 1 && isb == 1
        legend(lgndobjs, 'numcolumns', 2, 'location', 'northwest')
        xlabel('$\nu$'); ylabel('$\mathcal{M}(\nu)$');
        end
    end
end

%%
beta_vec = [-1,0,1];
sigma_beta_vec = [0.1,0.5,1,2,4];

n_betas = length(beta_vec);
n_sigbets = length(sigma_beta_vec);

cmap = return_colorbrewer('Spectral', length(sigma_beta_vec))*0.9;

figure; 

for ib = 1:n_betas
    subplot(1,n_betas,ib); hold on; 
    set(gca, 'colororder', cmap);
    for isb = 1:n_sigbets
        beta = beta_vec(ib);
        sigma_beta = sigma_beta_vec(isb);
        
        lambda_integrateds = arrayfun(@(g) theo_max_lyapunov_with_bias(g,beta,sigma_beta), g_vec);
        plot(g_vec, lambda_integrateds)
    end
    legend('show')
end
%%
beta_vec = [-0.5,0,0.5];
sigma_beta_vec = linspace(0.0,0.5,20);
g_vec = linspace(0.5,2.5,20); 

n_betas = length(beta_vec);
n_sigbets = length(sigma_beta_vec);
n_gvars = length(g_vec); 

figure; 

for ib = 1:n_betas
    subplot(2,2,ib); hold on; 
    
    sign_lambdas = zeros(n_sigbets,n_gvars); 
    beta = beta_vec(ib);
    parfor isb = 1:n_sigbets
        sigma_beta = sigma_beta_vec(isb);
        
        lambda_integrateds = arrayfun(@(g) theo_max_lyapunov_with_bias(g,beta,sigma_beta), g_vec); 
        sign_lambdas(isb,:) = sign(lambda_integrateds);
    end
    image(g_vec,sigma_beta_vec, sign_lambdas, 'cdatamapping', 'scaled')
end
