run start_up.m
load('data/lyapunov_gain_and_bias.mat', ...
    'beta_vec', 'sigma_beta_vec', 'g_vec', 'all_sign_lambdas', ...
    'n_betas', 'n_sigbets', 'n_gvars');

%%
graphic_reset(22, ...
    'DefaultAxesMinorGridAlpha', 0.05, ...
    'DefaultAxesMinorGridLineStyle', '-', ...
    'DefaultTextInterpreter', 'latex', ...
    'DefaultLegendInterpreter', 'latex', ...
    'DefaultAxesLineWidth', 2, ...
    'DefaultLineLineWidth', 3, ...
    'DefaultAxesLabelFontSize', 1.2, ...
    'DefaultAxesTitleFontSize', 1.2);
cmap_order = [0.95,0.95,1;1,0.9,0.95];
splt_locs = [1:4:16,2:4:16,[3,4]];
figure('units', 'normalized', 'Position', [0,0,0.8,0.9]);
for i = 1:n_betas
    subplot(4,4,splt_locs(i)); hold on; 
    image(g_vec, sigma_beta_vec,  all_sign_lambdas{i}, 'cdatamapping', 'scaled'); 
   
    colormap(gca, cmap_order);
    xlim(g_vec([1,end]));  ylim(sigma_beta_vec([1,end]));
    box on; xticks(''); yticks('');
    title(sprintf('$\\beta = %.2f$', beta_vec(i))); 
    pbaspect([1,1,1]);
    
    if i == 1
        text(0.6,0.4, 'order', 'fontsize', 20)
        text(1.4,0.1, 'chaos', 'fontsize', 20)
    end
end
 
subplot(4,4,[11,12,15,16]); hold on;
arrayfun(@(x)  visboundaries(all_sign_lambdas{x} > 0, 'color', [cmap(x,:) 0.7], 'linewidth', 3), ...
    1:n_betas)
xlim([0,n_gvars]); ylim([0,n_sigbets]);
ax_pos = get(gca, 'position'); 
ax_pos = ax_pos.*[1,1,1.4,1.4] + [-0.05,0.02,0,0];


plt_xticks = [1,25,50,100]; 
plt_yticks = [1,25,50,75,100];
set(gca, 'position', ax_pos, ...
    'xtick', plt_xticks, 'xticklabel', arrayfun(@(g) sprintf('%.1f', g), g_vec(plt_xticks), 'uni', 0), ...
    'ytick', plt_yticks, 'yticklabel', arrayfun(@(g) sprintf('%.1f', g), sigma_beta_vec(plt_yticks), 'uni', 0));
pbaspect([1,1,1]); 
xlabel('$g$'); ylabel('$\sigma_{\beta}$');

text(10,70,['order' newline '($\lambda < 0$)'], 'fontsize', 27);
text(74,20,['chaos' newline '($\lambda > 0$)'], 'fontsize', 27);

title('boundaries between order and chaos');

despline;

colormap(gca, cmap);
cbar = colorbar(gca); 
caxis(gca, beta_vec([1,end]));
title(cbar, '\beta')
cbar.Position = cbar.Position .* [1,1,1.2,0.4] + [0.02,0.02,0,0];

export_fig('figures/Fig6', '-r300', '-p0.02');