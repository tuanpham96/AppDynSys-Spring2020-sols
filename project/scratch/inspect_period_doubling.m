N = 300;
h0_sigma = 1;
h0 = h0_sigma * randn(N,1); 
tmax = 1000; 
g_vec = unique([0.9:0.02:2]);
pks = cell(length(g_vec), 1);

for ig = 1:length(g_vec)
    g = g_vec(ig); 
    [~, J_mat] = rnn_init(N);
    [t,h] = ode23(@(t,h) rnn_sys(h, g, J_mat), [0,tmax], h0');
    dh_hend = sqrt(sum((h-h(end,:)).^2,2));
    dh_hend = dh_hend(ceil(end/2):end);
    t = t(ceil(end/2):end);
    pks{ig} = unique(findpeaks(-dh_hend,t, 'minpeakdistance', 1));
end
%%
figure; hold on;
% arrayfun(@(g,pk) plot(ones(length(pk{1}))*g, pk{1}, 'k.', 'linestyle', 'none', ...
%     'markersize', 5), g_vec, pks');
arrayfun(@(g,pk) scatter(ones(length(pk{1}),1)*g, -pk{1}, 40, 'k', 'filled', 'markerfacealpha', 0.1), ...
    g_vec, pks');
ylim([-0.1, Inf]);