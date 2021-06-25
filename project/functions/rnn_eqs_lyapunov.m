function X = rnn_eqs_lyapunov(X, g, J_mat)
N = size(J_mat, 1); 
h = to_col_vec(X(1:N)); 
Y = reshape(X(N+1:end),[N,N]); 
jacob = rnn_jacobian(h, g, J_mat);

X(1:N) = rnn_sys(h, g, J_mat);
X(N+1:end) = jacob * Y; 

end