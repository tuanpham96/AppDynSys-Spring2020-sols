function dX = dQ4(X, a, tol)
x1 = X(1);
x2 = X(2);

f_plus  = [-1+x2;x2-x1];
f_minus = [-1-x2;x2+x1];

if ~isnan(a)
    if x2 > 0
        dX = f_plus;
    elseif x2 < 0
        dX = f_minus;
    else
        dX = a * f_plus + (1-a) * f_minus;
    end
    
elseif ~isnan(tol)
    if x2 > tol
        dX = f_plus;
    elseif x2 < -tol
        dX = f_minus;
    else
        dX = [-1+abs(x2); x2 + 0*(1-x1/tol)];
    end
    
else
    error('Scream out loud');
end

end