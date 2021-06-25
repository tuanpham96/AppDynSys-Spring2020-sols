function V = local_field_var(g, V, beta, sigma_beta)
if ~exist('beta', 'var'), beta = 0; end
if ~exist('sigma_beta', 'var'), sigma_beta = 0; end
dx = 0.01; 
x = to_row_vec(-5:dx:5); 
V = to_col_vec(abs(V)); 
Dx = dx * exp(-x.^2 /2)/sqrt(2*pi); 

V = sigma_beta^2 + (tanh(g*(sqrt(V) * x + beta)).^2) * Dx'; 
end