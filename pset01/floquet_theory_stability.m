clc; clear; 

s0 = [0.00001,0.00002];

% alpha_vec = linspace(0, 300, 200); 
% omega_vec = linspace(1, 100, 200);

alpha_vec = linspace(0, 300, 3000); 
omega_vec = linspace(1, 10, 100);

num_alpha = length(alpha_vec); 
num_omega = length(omega_vec); 

eig_mat = cell(num_alpha, num_omega); 
t0 = tic; 
parfor ia = 1:num_alpha
    ti = tic;
    for io = 1:num_omega
        alpha = alpha_vec(ia); 
        omega = omega_vec(io);
        mus = vibrate_my_pendulum(s0, alpha, omega);
        eig_mat{ia, io} = mus; 
    end   
    fprintf('\t\ti = %d/%d took %.2f secs\n', ia, num_alpha, toc(ti));
end
fprintf('Total time = %.2f secs\n', toc(t0));
% save('vibrate_200x200', 's0', 'alpha_vec', 'omega_vec', 'eig_mat') 
% save('vibrate_3000x100', 's0', 'alpha_vec', 'omega_vec', 'eig_mat') 
%%
example_positions = [...
    84.4221   77.1156
    84.4221   43.7839
    84.4221    8.9598
    214.0703   77.1156
    272.8643    8.4623
    272.8643    9.9548];
%%
comp_tol = 1e-3; 
load('vibrate_200x200.mat');
cmap = [0.55,0.55,0.55;0.93,0.92,0.92];
figure; 
colormap(cmap);
hold on; 
bounded_regime = cellfun(@(x) abs(x(1)) <= 1+comp_tol && abs(x(2)) <= 1+comp_tol, eig_mat);
bounded_regime(isnan(bounded_regime)) = 0; 
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

bound_edges = edge(bounded_regime, 'Canny', 0.5);
[rows, cols] = find(bound_edges);
low_bound_index = [rows(rows >= cols), cols(rows >= cols)];
upp_bound_index = [rows(rows < cols), cols(rows < cols)];
fit_lower = polyfit(omega_vec(low_bound_index(:,2)), alpha_vec(low_bound_index(:,1)), 2); 
fit_upper = polyfit(omega_vec(upp_bound_index(:,2)), alpha_vec(upp_bound_index(:,1)), 2); 
interp_omega = linspace(omega_vec(1),omega_vec(end), 1000); 
plot(polyval(fit_lower, interp_omega), interp_omega, ':k', 'linewidth', 5);
plot(polyval(fit_upper, interp_omega), interp_omega, ':k', 'linewidth', 5);

title('Regions of bounded solutions)');

example_colors = return_colorbrewer('Set2', size(example_positions,1));
scatter(example_positions(:,1), example_positions(:,2), 100, example_colors, ...
    'LineWidth', 2, 'Marker', 's');
print(gcf, 'floquet_200x200_regionsofbounded', '-dpng', '-r200')
%%

%%
num_periods = 50; 
for i = 1:size(example_positions, 1)
    figure; hold on; 
    alpha = example_positions(i,1);
    omega = example_positions(i,2);
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
    param_strings = sprintf('$$\\alpha = %.1f, \\omega = %.1f$$', alpha, omega);
    mu_strings = sprintf('$$\\mu_1 = %s, \\mu_2 = %s$$', num2str(mus(1), '%.2f'), num2str(mus(2), '%.2f'));
    text(-0.2,0.5,{param_strings, mu_strings}, ...
        'Color', example_colors(i,:), 'fontsize', 35, 'Interpreter', 'latex')
    set(gca, 'visible', 'off');
    
    pause(0.5); 
    
    print(gcf, sprintf('floquet_200x200_regionsofbounded_example_%02d', i), '-dpng', '-r200');
end

%%
load('vibrate_3000x100.mat');
cmap = [0.55,0.55,0.55;0.93,0.92,0.92];
figure; 
colormap(cmap);
hold on; 
bounded_regime = cellfun(@(x) abs(x(1)) <= 1 && abs(x(2)) <= 1, eig_mat);
bounded_regime(isnan(bounded_regime)) = 0; 
image(alpha_vec, omega_vec, bounded_regime', 'CDataMapping', 'scaled');
xlabel('\alpha'); ylabel('\omega');
xlim(alpha_vec([1,end])); ylim((omega_vec([1,end])));
pbaspect([1,1/6,1])
% pbaspect([1,1,1])
despline([0.3,2])
title('Regions of bounded solutions (zoomed in \omega + finer \alpha)');


