function phs = Q4phase(phase_win, a, tol)

[x,y] = meshgrid(...
    linspace(phase_win.x(1),phase_win.x(2),20), ...
    linspace(phase_win.y(1),phase_win.y(2),20));
u = zeros(size(x));
v = zeros(size(x));
for i = 1:numel(x)
    dS = dQ4([x(i);y(i)],a,tol);
    u(i) = dS(1);
    v(i) = dS(2);
end

phs.x = x;
phs.y = y;
phs.u = u;
phs.v = v;
end