clc;
clear all;
VT = 5;
Vu = 6;
theta_E = pi/2;
time = 0:0.01:100;
finPos = 0.5;
opts = odeset('Events', @(t,y)StopEventPos(t,y,finPos), 'RelTol', 1e-6, 'AbsTol', 1e-6);
odeDP = @(t,y) DP_noise(t,y,VT,Vu,theta_E);  % Anonymous derivative function with A
tspan = time;
f0 = [100;0];
[T,R_beta] = ode45(odeDP,tspan,f0,opts);  % Pass in column vector initial value

ode_traj = @(t,s) cal_traj_E(t,s,VT,theta_E);
[T_traj_E,traj_E] = ode45(ode_traj, T, f0,opts);
len_tra = length(T);

R_DP =R_beta(:,1);
beta_DP = R_beta(:,2);
x = traj_E(:,1)-R_DP.*cos(beta_DP);
y = traj_E(:,2)-R_DP.*sin(beta_DP);

lams = [1.5,2,2.5];
xpos_PP_all = {};
ypos_PP_all = {};
R_PP_all = {};

for i=1:1:length(lams)
    lambda = lams(i);
    ode_PP = @(t,y) PP_noise(t,y,VT,Vu,theta_E,lambda);
   
    y0 = [100;0];
    [T_PP,y_PP] = ode45(ode_PP,tspan,y0,opts);
    
    ode_traj = @(t,s) cal_traj_E(t,s,VT,theta_E);
    [T_traj_E,traj_E_PP] = ode45(ode_traj, T_PP, y0,opts);
    if(length(traj_E_PP)>length(traj_E))
        traj_E = traj_E_PP;
    end
    R_PP =y_PP(:,1);
    R_PP_all{i} = R_PP;
    beta_PP = y_PP(:,2);
    len_tra_PP = length(T_PP);
    %traj_E_PP = zeros(len_tra_PP,2);
    %traj_E_PP(:,1) = 100*ones(len_tra_PP,1);
    %traj_E_PP(:,2) = VT*T_PP;
    xpos_PP = traj_E_PP(:,1)-R_PP.*cos(beta_PP);
    ypos_PP = traj_E_PP(:,2)-R_PP.*sin(beta_PP);
    xpos_PP_all{i} = xpos_PP;
    ypos_PP_all{i} = ypos_PP;
end


figure(1)
hold on
plot(traj_E(:,1),traj_E(:,2));
plot(x,y);
for i=1:length(xpos_PP_all)
    x_pp = xpos_PP_all{i};
    y_pp = ypos_PP_all{i};
    plot(x_pp,y_pp);
end
legend('traj of E','traj of DP', 'traj of PP(\lambda=1.5)', 'traj of PP(\lambda=2)', 'traj of PP(\lambda=2.5)');
title("trajectory of E and P")

figure(2)
hold on
plot((0:1:length(R_DP)-1)/100, R_DP);
for i=1:length(R_PP_all)
    plot((0:1:length(R_PP_all{i})-1)/100,R_PP_all{i});
end
legend('R(DP)','R(\lambda=1.5)','R (\lambda=2)','R (\lambda=2.5)')
hold off
title("R versus time")


function dy = PP_noise(t,y,VT,Vu,theta_E,lambda)
%y(1) = R, y(2) = beta
R = y(1);
beta = y(2);
theta = lambda*(beta+0.25*randn);
d_R = VT*cos(beta-theta_E-cos(t))-Vu*cos(beta-theta);
d_beta = -(VT*sin(beta-theta_E-cos(t))-Vu*sin(beta-theta))/R;
dy = [d_R;d_beta];
end


function dy = DP_noise(t,y,VT,Vu,theta_E)
%direct DP
%y(1) = R, y(2) = beta
R = y(1);
beta = y(2);
theta = beta+0.25*randn;
dR = VT*cos(beta-theta_E-cos(t))-Vu*cos(beta-theta);
d_beta = -(VT*sin(beta-theta_E-cos(t))-Vu*sin(beta-theta))/R;
dy = [dR;d_beta];
end

function ds = cal_traj_E(t,s,VT,theta_E)
    dx = VT*cos(theta_E+cos(t));
    dy = VT*sin(theta_E+cos(t));
    ds = [dx;dy];
end

function [value, isterminal, direction] = StopEventPos(t, y, pos)
    value      = y(1) - pos;
    isterminal = 1;   % Stop the integration
    direction  = 0;
end