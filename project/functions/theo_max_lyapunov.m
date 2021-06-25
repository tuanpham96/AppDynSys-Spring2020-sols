function [lambda_integrated,lambda_analytical] = theo_max_lyapunov(g)
dx = 0.01; 
x = to_row_vec(-5:dx:5);
Dx = dx * exp(-x.^2 /2)/sqrt(2*pi); 

if g <= 1
    V = 0; 
    lambda_analytical = [log(g), nan]; 
else 
    V_vec = (0:0.001:1)';
    Vs = local_field_var(g,V_vec);
    [~, ind] = sort(abs(V_vec - Vs), 'ascend'); 
    Vs = Vs(ind(1:5)); 
    Vs = Vs(Vs > 0);
    V = [0,Vs(1)];
    lambda_analytical = [log(g), ...
        0.5*log(sqrt(2/(pi*V(2)))*g)];
end
lambda_integrated = arrayfun(@(V) 0.5 * log((g*(1-tanh(g*sqrt(V)*x).^2)).^2 * Dx'), V);
if length(lambda_integrated) == 1
    lambda_integrated = [lambda_integrated, nan]; 
end

end