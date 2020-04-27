function S = Q4sim(dt, nstep, S0, a, tol)
S = zeros(nstep, 2);
S(1,:) = S0; 
for i = 2:nstep 
    dS_dt = dQ4(S(i-1,:),a, tol)'; 
    S(i,:) = S(i-1,:) + dt * dS_dt;
end

end