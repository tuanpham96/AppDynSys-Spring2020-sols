clc; clear; close all; 

file_prefix = 'coarse_scan'; 
s0 = [0.00001,0.00002];
alpha_vec = linspace(0, 300, 200); 
omega_vec = linspace(1, 100, 200);

data_filename = fullfile(sprintf('data/%s.mat', file_prefix)); 
eig_mat = scan_my_pendulum_vibration(s0, alpha_vec, omega_vec, data_filename);

figure_filename = fullfile(sprintf('figures/%s.png', file_prefix)); 

text_filename = fullfile(sprintf('data/%s.txt', file_prefix)); 

%% Calculations before plottings 
comp_tol = 1e-5; 
bounded_regime = cellfun(@(x) abs(x(1)) <= 1+comp_tol && abs(x(2)) <= 1+comp_tol, eig_mat);
bounded_regime(isnan(bounded_regime)) = 0; 

bound_edges = edge(bounded_regime, 'Canny', 0.5);
[rows, cols] = find(bound_edges);
low_bound_index = [rows(rows >= cols), cols(rows >= cols)];
upp_bound_index = [rows(rows < cols), cols(rows < cols)];
fit_lower = polyfit(omega_vec(low_bound_index(:,2)), alpha_vec(low_bound_index(:,1)), 2); 
fit_upper = polyfit(omega_vec(upp_bound_index(:,2)), alpha_vec(upp_bound_index(:,1)), 2); 

%% Write some results to text file 
fid = fopen(text_filename, 'w'); 
fprintf(fid, 'Lower fit: \\alpha = %s \n',  poly2str(fit_lower, '\\omega'));
fprintf(fid, 'Upper fit: \\alpha = %s \n',  poly2str(fit_upper, '\\omega'));
fclose(fid); 

%% Plotting parameter space
example_paramsets = [...
    84.4221   77.1156
    84.4221   43.7839
    84.4221   8.9598
    214.0703   77.1156
    272.8643    8.4623
    272.8643    9.9548];

example_colors = return_colorbrewer('Set2', size(example_paramsets,1));


graphic_reset(35, ...
    'DefaultAxesLineWidth', 2, ...
    'DefaultLineLineWidth', 3, ...
    'DefaultAxesLabelFontSize', 2);

figure; 
colormap([0.7,0.7,0.7;0.95,0.94,0.94]);
hold on; 
image(alpha_vec, omega_vec, bounded_regime', 'CDataMapping', 'scaled');
xlabel('\alpha'); ylabel('\omega');
xlim(alpha_vec([1,end])); ylim((omega_vec([1,end])));
pbaspect([1,1,1])
despline;

cbar = colorbar; 
cbar_pos = cbar.Position; cbar_pos = cbar_pos.*[1,1,0.7,0.2] + [-0.1,0,0,0];
set(cbar, 'FontSize', 30, 'Position', cbar_pos, ...
    'Ticks', [0.25, 0.75], 'TickLabels', {'otherwise', '$$|\mu_1| \le 1 \land |\mu_2| \le 1$$'}, ...
    'TickLabelInterpreter', 'latex');
ttlcbar = title(cbar, 'Floquet multipliers');
set(ttlcbar, 'HorizontalAlignment', 'left')

interp_omega = linspace(omega_vec(1),omega_vec(end), 1000); 
plot(polyval(fit_lower, interp_omega), interp_omega, ':k', 'linewidth', 5);
plot(polyval(fit_upper, interp_omega), interp_omega, ':k', 'linewidth', 5);

title('Regions of bounded solutions');

scatter(example_paramsets(:,1), example_paramsets(:,2), 200, example_colors, ...
    'LineWidth', 2, 'Marker', 's');

warning off 
export_fig(figure_filename, '-r300', '-p0.02');
warning on 

close; 

%% Plotting examples
graphic_reset(30, ...
    'DefaultAxesLineWidth', 2, ...
    'DefaultLineLineWidth', 3, ...
    'DefaultAxesLabelFontSize', 1.5);

num_periods = 50; 
for i = 1:size(example_paramsets, 1)
    figure; hold on; 
    alpha = example_paramsets(i,1);
    omega = example_paramsets(i,2);
    T = 2*pi/omega; 
    
    [mus, t, s] = vibrate_my_pendulum(s0, alpha, omega, num_periods);
    
    subplot(211); hold on;
    yyaxis left;
    plot(t, s(:,1), '-k', 'linewidth', 3)
    set(gca, 'ycolor', 'k'); ylabel('x(t)'); 
    
    yyaxis right; 
    plot(t, s(:,2), '-', 'linewidth', 3, 'color', 0.7*ones(1,3))
    set(gca, 'ycolor',  0.7*ones(1,3)); ylabel('y(t)'); 
    xlim([0, t(end)]);
    xlabel('time (dashed = T = 2\pi/\omega)');
    
    arrayfun(@(x) xline(x*T, '--k'), 1:num_periods);
    
    
    subplot(223); hold on;
    plot(s(:,1), s(:,2), '-k', 'linewidth', 3);
    xlabel('x(t)'); ylabel('y(t)');
    set(gca, 'xtick', '', 'ytick', ''); 
    
    subplot(224); hold on;
    param_strings = {sprintf('$$\\alpha = %.1f, \\omega = %.1f$$', alpha, omega)};
    if isreal(mus(1))
        mu_strings = {sprintf('$$\\mu_1 = %s, \\mu_2 = %s$$', num2str(mus(1), '%.2f'), num2str(mus(2), '%.2f'))};
    else        
        mu_strings = {sprintf('$$\\mu_1 = %s$$', num2str(mus(1), '%.2f')), ...
            sprintf('$$\\mu_2 = %s$$', num2str(mus(2), '%.2f'))};
    end
    text(-0.2,0.5, [param_strings, mu_strings], ...
        'Color', example_colors(i,:) * 0.8, 'fontsize', 70, 'Interpreter', 'latex', 'FontWeight', 'bold')
    set(gca, 'visible', 'off');
    
    exfigure_filename = fullfile(sprintf('figures/%s_example_%02d.png', file_prefix, i));
    warning off
    export_fig(exfigure_filename, '-r300', '-p0.02');
    warning on
    
    close; 

end

