function lambda_integrated = theo_max_lyapunov_with_bias(g,beta,sigma_beta)
dx = 0.01; 
x = to_row_vec(-5:dx:5);
Dx = dx * exp(-x.^2 /2)/sqrt(2*pi); 

    V_vec = (0:0.001:(sigma_beta^2+1))';
    Vs = local_field_var(g,V_vec,beta,sigma_beta);
    [~, ind] = sort(abs(V_vec - Vs), 'ascend'); 
    Vs = Vs(ind(1:5)); 
    Vs = Vs(Vs > 0);
    V = Vs(1); 
    
lambda_integrated = 0.5 * log((g*(1-tanh(g*(sqrt(V)*x+beta)).^2)).^2 * Dx');

end