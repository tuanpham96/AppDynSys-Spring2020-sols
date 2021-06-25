function dh_dt = rnn_sys(h, g, J_mat)
dh_dt = -h + J_mat*tanh(g.*h);
end