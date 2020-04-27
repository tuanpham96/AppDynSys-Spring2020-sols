function eig_mat = scan_my_dampened_vibrating_pendulum(s0, alpha_vec, omega_vec, beta_vec, save_filename)
if exist(save_filename, 'file')
    fprintf('The file "%s" already exists. Will load the file instead!\n', save_filename);
    dat = load(save_filename);
    is_s0_equal = isequal(dat.s0, s0)  || (isequal(isnan(dat.s0), isnan(s0)));
    if ~is_s0_equal || ~isequal(dat.alpha_vec, alpha_vec) || ~isequal(dat.omega_vec, omega_vec) || ~isequal(dat.beta_vec, beta_vec)
        error('The parameters of the loaded data do not match with the inputs!');
    end
    eig_mat = dat.eig_mat;
    return;
end

num_alpha = length(alpha_vec);
num_omega = length(omega_vec);
num_beta  = length(beta_vec);

eig_mat = cell(num_alpha, num_omega, num_beta);
t0 = tic;
parfor ia = 1:num_alpha
    ti = tic;
    for io = 1:num_omega
        for ib = 1:num_beta
            
            alpha = alpha_vec(ia);
            omega = omega_vec(io);
            beta  = beta_vec(ib);
            
            [~, ~, ~, mus] = vibrate_my_dampened_pendulum(s0, alpha, omega, beta);
            eig_mat{ia, io, ib} = mus;
        end
    end
    fprintf('\t\ti = %d/%d took %.2f secs\n', ia, num_alpha, toc(ti));
end
fprintf('Total time = %.2f secs\n', toc(t0));

save(save_filename, 's0', 'alpha_vec', 'omega_vec', 'eig_mat', 'beta_vec');

end