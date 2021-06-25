N = 100; 

%%
g = 5; 
J = 1;

[h0, J_mat] = rnn_init(N, J);

tmax = 100; 
[t,h] = ode23(@(t,h) rnn_sys(h, g, J_mat), [0,tmax], h0');

figure; 
subplot(211); hold on; 
plot(t, h(:,randperm(N,10)));
subplot(212); hold on; 
dh2 = sum(h.^2,2);
plot(dh2(1:end-1), diff(dh2));
%%
rand_combos = randperm(N,3); 
i1 = rand_combos(1); i2 = rand_combos(2); i3 = rand_combos(3); 
t_vec = ceil(length(t)/3):length(t);
figure; hold on;
plot3(h(t_vec,i1), h(t_vec,i2), h(t_vec,i3), 'linewidth', 0.2, 'color',[0.8,0.8,0.8,0.1]);
scatter3(h(t_vec,i1), h(t_vec,i2), h(t_vec,i3), ...
    20, jet(length(t_vec)), 'filled');
%%

tic
[T,Res]=lyapunov(N,@(t,X) rnn_eqs_lyapunov(X, g, J_mat),@ode23,...
    0,1,tmax,h0',0);
toc

%%
figure;
plot(T,Res, 'k');
title('Dynamics of Lyapunov exponents');
xlabel('Time'); ylabel('Lyapunov exponents');


yyaxis right 
plot(T,max(Res,[],2), 'r');