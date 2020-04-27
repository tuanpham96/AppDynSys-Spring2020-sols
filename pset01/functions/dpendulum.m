function ds = dpendulum(t, s, alpha, omega) 
ds = [  s(2); ...
        (1+alpha*cos(omega*t))*s(1) ]; 
end