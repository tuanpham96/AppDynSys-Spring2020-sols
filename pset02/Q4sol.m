%% Startup 
clc; clear; close all
run start_up.m
%% Choose parameters 
a_vec = [0.1,0.5,0.9]; 
tol_vec = [1e-5, 0.5, 2]; 

dt = 1e-4;
t = 0:dt:200;
phase_win.x = [-10,25];
phase_win.y = [-10,10];

d_perturb = [0,1e-5]; 
S0_init = {[0.5,0.1],[-0.8,0.05]}; 

%% Create initial conditions with perturbation and changed y-sign 
S0v = cell(length(S0_init),1); 
for i = 1:length(S0v)
    S0 = S0_init{i};
    S0v{i} = { S0, S0+d_perturb, S0.*[1,-1], S0.*[1,-1]+d_perturb };
end
S0v = horzcat(S0v{:});

%% Run simulation
nstep = length(t);

Sv_as = cell(length(a_vec),1);
Ph_as = Sv_as; 
tic
parfor i = 1:length(a_vec)
    a = a_vec(i); 
    tol = nan; 
    [Sv_as{i}, Ph_as{i}] = Q4simnphase(dt, nstep, a, tol, S0v, phase_win);
end
toc

Sv_tol = cell(length(tol_vec),1);
Ph_tol = Sv_tol; 
parfor i = 1:length(tol_vec)
    tol = tol_vec(i); 
    a = nan; 
    [Sv_tol{i}, Ph_tol{i}] = Q4simnphase(dt, nstep, a, tol, S0v, phase_win);
end
toc

%% Define what to plot
num_inits = round(length(S0v)/2); 

% Sv_2plt = Sv_as; 
% Phs_2plt = Ph_as; 
% var_name = '\alpha'; 
% var2plt = a_vec;
% 
% exfigure_filename = 'Q4_alpha'; 

Sv_2plt = Sv_tol; 
Phs_2plt = Ph_tol; 
var_name = '\eta_y'; 
var2plt = tol_vec;

exfigure_filename = 'Q4_tol'; 

cmap = [0.81,0.1,0.1;0.3,0.6,0.8];
cmap = [cmap, 0.5*ones(size(cmap,1),1)];

%% Now plot 

figure; 
cnt_splt = 1; 

for i = 1:length(var2plt)
    cnt_init = 1;
    for j = 1:num_inits
        subplot(length(var2plt),num_inits,cnt_splt); hold on;
        Sv = Sv_2plt{i}(cnt_init:cnt_init+1); 
        Phs = Phs_2plt{i}; 
        Q4singleplot(gca, Sv, Phs, cmap);
        
        xlim(phase_win.x); ylim(phase_win.y);
        set(gca, 'xtick', '', 'ytick', '', 'box', 'on'); 
        
        if i == 1 
            s0 = Sv{1}(1,:);
            title(sprintf('$$s_0=[%.1g,%.1g]$$', s0(1), s0(2)), 'Interpreter', 'latex');
        end
        
        if j == 1 
            ylabel(sprintf('$$ %s=%.1g$$', var_name, var2plt(i)), 'Interpreter', 'latex');
        end
        
        if cnt_splt == length(var2plt)*num_inits
            xlabel('x','Interpreter', 'latex'); ylabel('y','Interpreter', 'latex')
        end
        
        cnt_splt = cnt_splt + 1;
        cnt_init = cnt_init + 2;
        
    end
end


export_fig(exfigure_filename, '-r300', '-p0.02');

%% Plot explanation of tol 
x = 10;
y = -50:0.01:50;
tol = 3;
fy = zeros(size(y));
fy(y > 0) = y(y>0) - x; 
fy(y < 0) = y(y<0) + x; 

lgdnobj = gobjects(2,1);
figure; hold on; 

xline(0, '-', 'color', [0.8,0.8,0.8],'linewidth',2);
yline(0, '-', 'color', [0.8,0.8,0.8], 'linewidth',2);

lgdnobj(1) = plot(y,fy, '-k','linewidth', 4, 'displayname', 'original');

fy(y > tol) = y(y>tol) - x;
fy(y < -tol) = y(y<-tol) + x;


fy(y >= -tol & y <= tol) = y(y >= -tol & y <= tol) * (1-x/tol);
lgdnobj(2) = plot(y,fy, ':r', 'linewidth', 4,  'displayname', 'proposed change with \eta_y');

xlim([-20,20]); ylim([-20,20]);
set(gca, 'xtick', '', 'ytick', '')
xlabel('y','Interpreter', 'latex'); ylabel('f(y)','Interpreter', 'latex');
legend(lgdnobj, 'fontsize', 20)
hide_only_axis('xy')


export_fig('explanation_of_modification', '-r300', '-p0.02');
