function eig_mat = scan_my_pendulum_vibration(s0, alpha_vec, omega_vec, save_filename)
if exist(save_filename, 'file') 
    fprintf('The file "%s" already exists. Will load the file instead!\n', save_filename); 
    dat = load(save_filename, 'eig_mat', 's0', 'alpha_vec', 'omega_vec');
    if ~isequal(dat.s0, s0) || ~isequal(dat.alpha_vec, alpha_vec) || ~isequal(dat.omega_vec, omega_vec)
        error('The parameters of the loaded data do not match with the inputs!'); 
    end
    eig_mat = dat.eig_mat; 
    return;
end 

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

save(save_filename, 's0', 'alpha_vec', 'omega_vec', 'eig_mat'); 

end