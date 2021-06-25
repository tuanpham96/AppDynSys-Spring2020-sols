[T,Res]=lyapunov(3,@lorenz_ext,@ode23,0,1e-2,400,[1 0 0],1e5);
plot(T,Res);
title('Dynamics of Lyapunov exponents');
xlabel('Time'); ylabel('Lyapunov exponents');

