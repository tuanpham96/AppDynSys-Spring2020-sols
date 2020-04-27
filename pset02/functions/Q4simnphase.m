function [sim, phs] = Q4simnphase(dt, nstep, a, tol, S0v, phase_win)
sim = cellfun(@(S0) Q4sim(dt, nstep, S0, a, tol), S0v, 'uni', 0);
phs = Q4phase(phase_win, a, tol); 
end