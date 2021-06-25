graphic_reset(30, ...
    'DefaultAxesMinorGridAlpha', 0.05, ...
    'DefaultAxesMinorGridLineStyle', '-', ...
    'DefaultTextInterpreter', 'latex', ...
    'DefaultLegendInterpreter', 'latex', ...
    'DefaultAxesLineWidth', 3, ...
    'DefaultLineLineWidth', 4, ...
    'DefaultAxesLabelFontSize', 1.25, ...
    'DefaultAxesTitleFontSize', 1.25);

figure; 
subplot(121); hold on; 
g_vec = [0.1,0.25,0.5,1,2,4,10]; 
cmap = return_colorbrewer('Spectral', length(g_vec))*0.9;
V_vec = 0:0.01:2;

lgndobjs = arrayfun(@(g,c) plot(V_vec, local_field_var(g,V_vec), 'color', c{:}, ...
    'displayname', sprintf('g=%g',g)), g_vec, mat2colcell(cmap)');
plot(V_vec, V_vec, ':k'); 
xlabel('$\nu$'); ylabel('$\mathcal{M}(\nu)$');
title({'2nd-moment fixed points', '$\nu^* = \mathcal{M}(\nu^*)$'}); 
xlim([0,1.5]); ylim([0,1.5]); despline; daspect([1,1,1]);
legend(lgndobjs, 'numcolumns', 2, 'location', 'northwest');


subplot(122); hold on; 
g_vec = linspace(0.1,10,100); 
lambda_integrateds = arrayfun(@(g) theo_max_lyapunov(g), g_vec, 'uni', 0);
lambda_integrateds = vertcat(lambda_integrateds{:}); 
xline(1, ':', 'color', 0.8*ones(1,3), 'linewidth', 3); 
yline(0, ':', 'color', 0.8*ones(1,3), 'linewidth', 3);
lgndobjs = [plot(g_vec, lambda_integrateds(:,1), '-k', 'displayname', '$\lambda(\nu^* = 0)$'), ...
plot(g_vec, lambda_integrateds(:,2), 'color', 0.7*ones(1,3), 'displayname', '$\lambda(\nu^* > 0)$')];
xlabel('$g$'); ylabel('$\max \lambda$');
title({'maximum Lyapunov exponent', ' of discrete system (via integration)'});
legend(lgndobjs);
despline; axis square;
xticks([0,1,2,5,10]);

export_fig('figures/Fig3', '-r200', '-p0.02');