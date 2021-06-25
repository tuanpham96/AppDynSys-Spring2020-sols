run start_up.m

load('data/rnn_sim_lyapunov_finerscan.mat', ...
    'N_vec', 'g_vec', 'n_inits', 'n_nvars', 'n_gvars', 'tmax', 'dt_lyapunov', 'results');

%%
max_lambdas = cellfun(@(c) arrayfun(@(s) max(s.lyapunov.lambdas(end,:)), c), results, 'uni', 0);
max_lambdas = cellfun(@(x) vertcat(x{:}), mat2colcell(max_lambdas), 'uni', 0);

%%
cmap = return_colorbrewer('Set1'); 
graphic_reset(20, ...
    'DefaultAxesMinorGridAlpha', 0.05, ...
    'DefaultAxesMinorGridLineStyle', '-', ...
    'DefaultTextInterpreter', 'latex', ...
    'DefaultLegendInterpreter', 'latex', ...
    'DefaultAxesLineWidth', 2, ...
    'DefaultLineLineWidth', 3, ...
    'DefaultAxesLabelFontSize', 1.2, ...
    'DefaultAxesTitleFontSize', 1.2);

figure('units','normalized', 'position',[0.1,0.1,0.8,0.8]);

subplot(3,1,[1,2]); 
hold on; 
p_vals = cell(n_nvars,1);
lgnd_objs = gobjects(n_nvars,1);
for i = 1:n_nvars
    N = N_vec(i); 
    lambdas_of_N = max_lambdas{i}; 
    mean_lambda = mean(lambdas_of_N,2)'; 
    sem_lambda = std(lambdas_of_N,0,2)'/sqrt(n_inits); 
    
    lower_bound = mean_lambda + sem_lambda;
    upper_bound = mean_lambda - sem_lambda;
    
    [~,p_vals{i}] = ttest(lambdas_of_N');
    lgnd_objs(i) = plot(g_vec, mean_lambda, '-', 'color', cmap(i,:), 'displayname', sprintf('$N=%d$', N));
    fill([g_vec fliplr(g_vec)], [upper_bound fliplr(lower_bound)], cmap(i,:), ...
        'FaceAlpha', 0.2,'linestyle', 'none');
end

xline(1, ':', 'color', 0.8*ones(1,3), 'linewidth', 3); 
yline(0, ':', 'color', 0.8*ones(1,3), 'linewidth', 3);

text(1.1, -0.1, sprintf('$T=%g$, %d realizations each (mean $\\pm$ SEM)', tmax, n_inits), ...
    'fontsize', 25);
ylabel('$\max \lambda$'); 
title('max Lyapunov exponent from simulation (closer look at $g \approx 1$)');
set(gca,'xcolor','none');
legend(lgnd_objs)

subplot(313); hold on; 
set(gca,'colororder', cmap);
p_vals = vertcat(p_vals{:}); 
bar(g_vec, log(p_vals), 1, 'linestyle','none', 'FaceAlpha', 0.8); 
lgnd_objs = arrayfun(@(p,m,s) yline(log(p), s{:}, 'color', m*ones(1,3), 'linewidth',2, ...
    'displayname', sprintf('$\\alpha=%g$', p)), ...
    [0.1,0.05,0.01], [0.6,0.6,0.6], {'--',':','-'});

xticks(g_vec); xtickangle(90);
legend(lgnd_objs, 'numcolumns', 3)
xlabel('$g$'); ylabel('log(p-value)');
title('p-values of t-test with null hypothesis $H_0: \langle \lambda \rangle = 0$')  

linkaxes(findall(gcf,'type','axes'), 'x');
xlim([0.9,2.05])
despline('all',[0.1,0.1])


export_fig('figures/Fig5', '-r200', '-p0.02');