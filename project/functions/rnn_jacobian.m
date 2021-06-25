function jacob = rnn_jacobian(h,g,J_mat)
jacob = -J_mat .* (tanh(g*h).^2-1)' * g - eye(size(J_mat)); 
end