function ds = dpendulum_withdampen(t, s, alpha, omega, beta) 
ds = [  s(2); ...
        (1+alpha*cos(omega*t))*s(1) - beta*s(2)]; 
end