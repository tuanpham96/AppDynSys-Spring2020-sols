x = -5:0.1:5; 
a_vec = [0.01,0.1,1,10,100]; 
cmap = jet(length(a_vec)); 
figure; hold on; 
for i = 1:length(a_vec)
    a = a_vec(i); 
    plot(x, log(cosh(a*x))/a, 'color', cmap(i,:), ...
        'displayname', sprintf('a=%g', a));
end

legend('show');
%%
g_vec = [0.01,0.1,0.5,1,2,5,10];
V_vec = 0:0.01:2; 
cmap = jet(length(g_vec)); 
figure; hold on; 
lgndobjs = arrayfun(@(g,c) plot(V_vec, local_field_var(g,V_vec), 'color', c{:}, ...
    'displayname', sprintf('g=%g',g)), g_vec, mat2colcell(cmap)');
plot(V_vec, V_vec, ':k'); 
xlim([0,1.5]); ylim([0,1.5]); 
daspect([1,1,1]); 
legend(lgndobjs);
%%
x = -5:0.1:5; 
a_vec = [0.01,0.1,1,10,100]; 
cmap = jet(length(a_vec)); 
figure; hold on; 
for i = 1:length(a_vec)
    a = a_vec(i); 
    plot(x, tanh(a*x), 'color', cmap(i,:), ...
        'displayname', sprintf('a=%g', a));
end
plot(x,x);
legend('show');
%%