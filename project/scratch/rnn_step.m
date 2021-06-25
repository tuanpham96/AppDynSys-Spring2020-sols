function h = rnn_step(h, g, J_mat, dt)
dh_dt = rnn_sys(h, g, J_mat);
h = h + dh_dt * dt; 
end