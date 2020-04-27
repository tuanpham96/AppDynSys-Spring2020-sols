function [t,s] = euler_pendulum(dt, tmax, s0, alpha, omega)
n_steps = ceil(tmax/dt); 
t = (0:n_steps)*dt;
s = zeros(length(t), length(s0)); 
s(1,:) = s0; 
for i = 1:n_steps
    x = s(i,1); 
    y = s(i,2); 
    dx = dt * y; 
    dy = dt * (1+alpha*cos(omega*t(i)))*x; 
    
    s(i+1,1) = x + dx;
    s(i+1,2) = y + dy;
end 
end
