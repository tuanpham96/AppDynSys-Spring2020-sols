function [h0, J_mat] = rnn_init(N, J, h0_sigma)
if ~exist('J', 'var'), J = 1; end
if ~exist('h0_sigma', 'var'), h0_sigma = 1; end 
h0 = h0_sigma * randn(N,1); 
J_var = J^2 / N; 
J_mat = sqrt(J_var) * randn(N);
zero_self = 1 - eye(N); 
J_mat = J_mat .* zero_self; 
end