clc; clear; close all; 

file_prefix = 'figures/dampen_example';
examples_paramsets = struct; 
examples_paramsets.reals = struct('alpha', 50, 'omega', 10, 'beta', 10);
examples_paramsets.complex = struct('alpha', 120, 'omega', 15, 'beta', 10);

example_types = fieldnames(examples_paramsets);

max_nperios = 10;
s0 = [0.001,0.002];


graphic_reset(35, ...
    'DefaultAxesLineWidth', 3, ...
    'DefaultLineLineWidth', 5, ...
    'DefaultAxesLabelFontSize', 1.2);

for i  = 1:length(example_types)
    figure;
    prm = examples_paramsets.(example_types{i}); 
    alpha = prm.alpha; 
    omega = prm.omega; 
    beta  = prm. beta; 
    [t, s] = vibrate_my_dampened_pendulum(s0, alpha, omega, beta, max_nperios);
    [~, ~, ~, mus] = vibrate_my_dampened_pendulum(nan, alpha, omega, beta);
    
    T = 2*pi/omega;
    
    subplot(211); hold on;
    yyaxis left;
    plot(t, s(:,1), '-k')
    set(gca, 'ycolor', 'k'); ylabel('x(t)'); 
    yyaxis right; 
    plot(t, s(:,2), '-', 'color', 0.7*ones(1,3))
    set(gca, 'ycolor',  0.7*ones(1,3)); ylabel('y(t)'); 
    xlim([0, t(end)]);
    xlabel('time (dashed = T = 2\pi/\omega)');
    arrayfun(@(x) xline(x*T, '--k', 'linewidth', 2), 1:max_nperios);
    
    
    subplot(223); hold on;
    plot(s(:,1), s(:,2), '-k')
    xlabel('x(t)'); ylabel('y(t)');
    set(gca, 'xtick', '', 'ytick', ''); 
    subplot(224); hold on;
    param_strings = {sprintf('$$\\alpha = %d, \\omega = %d, \\beta = %d$$', alpha, omega, beta)};
    if isreal(mus(1))
        mu_strings = {sprintf('$$\\mu_1 = %s, \\mu_2 = %s$$', num2str(mus(1), '%.3g'), num2str(mus(2), '%.3g'))};
    else        
        mu_strings = {sprintf('$$\\mu_1 = %s$$', num2str(mus(1), '%.3g')), ...
            sprintf('$$\\mu_2 = %s$$', num2str(mus(2), '%.3g'))};
    end
    
    text(-0.2,0.5, [param_strings, mu_strings], 'fontsize', 60, 'Interpreter', 'latex', 'FontWeight', 'bold')
    set(gca, 'visible', 'off');
    
    exfigure_filename = sprintf('%s_%s.png', file_prefix, example_types{i});
    warning off
    export_fig(exfigure_filename, '-r300', '-p0.02');
    warning on
    
    close; 
        
end
