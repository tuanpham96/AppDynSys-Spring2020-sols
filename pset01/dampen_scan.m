clc; clear; close all; 

file_prefix = 'dampen_scan'; 
alpha_vec = linspace(0, 150, 50); 
omega_vec = linspace(1, 50, 50);
beta_vec  = linspace(0, 50, 25); 


data_filename = fullfile(sprintf('data/%s.mat', file_prefix)); 
eig_mat = scan_my_dampened_vibrating_pendulum(nan, alpha_vec, omega_vec, beta_vec, data_filename);

figure_filename = fullfile(sprintf('figures/%s.png', file_prefix)); 

%% Calculations before plotting 
comp_tol = 1e-5;
stable_regimes = arrayfun(@(ib) ...
    cellfun(@(x) abs(x(1)) < 1-comp_tol && abs(x(2)) < 1-comp_tol, squeeze(eig_mat(:,:,ib))), ...
    1:length(beta_vec), 'uni', 0);

%% Plotting
num_beta_2plot = length(beta_vec) - 1;
graphic_reset(20, ...
    'DefaultAxesLineWidth', 2.5, ...
    'DefaultLineLineWidth', 3, ...
    'DefaultAxesLabelFontSize', 2);

mat_layout = zeros(7,7);
mat_layout(3:7,3:7) = 1; 
ind_combined = find(mat_layout); 
ind_individual = find(~mat_layout);

cmap = return_colorbrewer('Spectral', num_beta_2plot) * 0.9;

figure('units', 'normalized', 'position', [0         0    0.7255    0.8870]);
for i = 1:num_beta_2plot
    beta_val = beta_vec(i); 
    subplot(7,7,ind_individual(i)); hold on
    colormap(gca, [0.7,0.7,0.7;0.95,0.94,0.94]); 
    image(stable_regimes{i}', 'CDataMapping', 'scaled'); 
    axis square
    pos = get(gca, 'Position');
    ylabel(sprintf('\\beta = %.1f', beta_val), 'fontsize', 20, 'color', cmap(i,:), 'fontweight', 'bold');
    set(gca, 'xtick', '', 'ytick', '', 'box', 'on');
end

subplot(7,7,ind_combined); hold on;
arrayfun(@(x)  visboundaries(stable_regimes{x}', 'color', [cmap(x,:) 0.7], 'linewidth', 5), ...
    1:num_beta_2plot)
despline(0.1);
xlabel('\alpha'); ylabel('\omega'); title('boundaries of stable regimes');
set(gca, 'xtick', [1,length(alpha_vec)], 'xticklabel', alpha_vec([1,end]), ...
    'ytick', [1,length(omega_vec)], 'yticklabel', omega_vec([1,end]));
pbaspect([1,1,1]); despline;
ax_pos = get(gca, 'Position');
ax_pos = ax_pos + [-0.02,0,0,0];
set(gca, 'Position', ax_pos); 
colormap(gca, cmap); 
cbar = colorbar; 
cbar_pos = cbar.Position; 
cbar_pos = cbar_pos .* [1,1,1.2,0.6] + [0.03,0.02,0,0];
set(cbar, 'Position', cbar_pos);
ylabel(cbar, '\beta');
caxis(beta_vec([1, num_beta_2plot])); 

keystop = 'w'; 
while ~strcmpi(keystop, 's') % for editing
    waitforbuttonpress; 
    keystop = get(gcf, 'CurrentCharacter'); 
end

warning off 
export_fig(figure_filename, '-r300', '-p0.02');
warning on 

