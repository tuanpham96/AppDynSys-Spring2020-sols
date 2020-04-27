clc; clear; close all; 

file_prefix = 'fine_scan'; 
s0 = [0.00001,0.00002];
alpha_vec = linspace(0, 300, 3000); 
omega_vec = linspace(1, 10, 100);


data_filename = fullfile(sprintf('data/%s.mat', file_prefix)); 
eig_mat = scan_my_pendulum_vibration(s0, alpha_vec, omega_vec, data_filename);

figure_filename = fullfile(sprintf('figures/%s.png', file_prefix)); 

%% Calculations before plottings 
comp_tol = 1e-5; 
bounded_regime = cellfun(@(x) abs(x(1)) <= 1+comp_tol && abs(x(2)) <= 1+comp_tol, eig_mat);
bounded_regime(isnan(bounded_regime)) = 0; 

figure; 
graphic_reset(60, ...
    'DefaultAxesLineWidth', 2, ...
    'DefaultLineLineWidth', 3, ...
    'DefaultAxesLabelFontSize', 2);

colormap([0.7,0.7,0.7;0.95,0.94,0.94]); hold on; 
image(alpha_vec, omega_vec, bounded_regime', 'CDataMapping', 'scaled');
xlabel('\alpha'); ylabel('\omega');
xlim(alpha_vec([1,end])); ylim(omega_vec([1,end]) + [-1,0]);
yticks([1, 5, 10]);
pbaspect([1,1/3,1])
despline([0.8,0.5])
title('(zoomed in \omega + finer \alpha)');


warning off 
export_fig(figure_filename, '-r300', '-p0.02');
warning on 

close; 
