run start_up.m

load('data/rnn_sim_lyapunov.mat', ...
    'N', 'g_vec', 'n_inits', 'n_gvars', 'tmax', 'dt_lyapunov', 'results'); 
%%
max_lambdas = cellfun(@(c) arrayfun(@(s) max(s.lyapunov.lambdas(end,:)), c), results, 'uni', 0);
% max_lambdas = cellfun(@(c) arrayfun(@(s) max(s.lyapunov.lambdas(:)), c), results, 'uni', 0);
max_lambdas = vertcat(max_lambdas{:});
rep_gvec = repmat(g_vec', [1,n_inits]); 
rep_gvec = rep_gvec(:);

%% Example setup 
g_vec2plot = [0.9, 1, 2, 5, 10]; 
ind_g2plot = arrayfun(@(g) find_nearest(g_vec, g, 'ind'), g_vec2plot);
splt_ind = [1,4,7,8,9]; 
n_rand2plot = 5; 
cmap = return_colorbrewer('Set2', n_rand2plot);


graphic_reset(20, ...
    'DefaultAxesMinorGridAlpha', 0.05, ...
    'DefaultAxesMinorGridLineStyle', '-', ...
    'DefaultTextInterpreter', 'latex', ...
    'DefaultLegendInterpreter', 'latex', ...
    'DefaultAxesLineWidth', 2, ...
    'DefaultLineLineWidth', 3, ...
    'DefaultAxesLabelFontSize', 1.2, ...
    'DefaultAxesTitleFontSize', 1.2);

figure('units', 'normalized', 'position', [0.02,0.02,0.7,0.7]);
set(gcf, 'defaultaxescolororder', cmap);
for i = 1:length(ind_g2plot)
    subplot(3,3,splt_ind(i)); hold on;
    sample_sim = results{ind_g2plot(i)}(2).sim;
    plot(sample_sim.t, sample_sim.h(:,randperm(N,n_rand2plot)), ...
        'linewidth', 2);
    title(sprintf('$g=%g$',g_vec2plot(i)));
    despline
    
    if splt_ind(i) == 7
        xlabel('$t$'); 
        ylabel('$h_i(t)$'); 
    end
end


subplot(3,3,[2,3,5,6]); hold on; 
xline(1, ':', 'color', 0.8*ones(1,3), 'linewidth', 3); 
yline(0, ':', 'color', 0.8*ones(1,3), 'linewidth', 3);
plot(g_vec, mean(max_lambdas,2), 'color', [0.1,0.1,0.1,0.5], 'tag', 'legendon', ...
    'displayname', sprintf('averaged from %d realizations', n_inits));
scatter(rep_gvec, max_lambdas(:), 80, 'k', 'filled', ...
    'markeredgealpha', 0, 'markerfacealpha', 0.08);
xlabel('$g$'); ylabel('$\max \lambda$'); 
title(sprintf('max Lyapunov exponent from simulation $(N = %d)$', N));
despline; 
ax_pos = get(gca, 'Position');
ax_pos = ax_pos.*[1,1,0.76,0.8] + [0.08,0.08,0,0];
set(gca, 'position', ax_pos); 
xticks([0,1,2,5,10]);
legend(findobj(gca, 'tag', 'legendon'));


% export_fig('figures/Fig4', '-r200', '-p0.02');