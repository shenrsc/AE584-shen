clc;
clear all;
VT = 5;
Vui = [6,8,11];
Vu = 6;
theta = asin(VT/Vu);
theta_E = pi/2;
time = 0:0.01:100;
finPos = 0;
opts = odeset('Events', @(t,y)StopEventPos(t,y,finPos), 'RelTol', 1e-6, 'AbsTol', 1e-6);
tspan = time;

figure(1)
R_DP_all = {};
T_DP_all = {};
R_CBP_all = {};
T_CBP_all = {};
for i=1:3
Vu = Vui(i);
theta = asin(VT/Vu);
%%
%calculate DP
odefun = @(t,y) deriv(t,y,VT,Vu,theta_E);  % Anonymous derivative function with A
f0 = [100;0];
[T,R_beta] = ode45(odefun,tspan,f0,opts);

len_tra = length(T);
traj_E = zeros(len_tra,2);
traj_E(:,1) = 100*ones(len_tra,1);
traj_E(:,2) = VT*T;
R = R_beta(:,1);
beta = R_beta(:,2);
x_DP = traj_E(:,1)-R.*cos(beta);
y_DP = traj_E(:,2)-R.*sin(beta);
R_DP_all{i} = R;
T_DP_all{i} = T;
%%
%to calculate CBP
beta_CBP = 0;
ode_CBP = @(t,R) CBP(t,R,VT,Vu,theta_E,theta,beta_CBP);
R0 = 100;
[T_CBP,R_CBP] = ode45(ode_CBP,tspan,R0,opts);
len_tra_CBP = length(T_CBP);
traj_E_CBP = zeros(len_tra_CBP,2);
traj_E_CBP(:,1) = 100*ones(len_tra_CBP,1);
traj_E_CBP(:,2) = VT*T_CBP;
x_CBP = traj_E_CBP(:,1)-R_CBP.*cos(beta_CBP);
y_CBP = traj_E_CBP(:,2)-R_CBP.*sin(beta_CBP);
R_CBP_all{i} = R_CBP;
T_CBP_all{i} = T_CBP;
%%
%plot
subplot(1,3,i)
hold on
plot(traj_E(:,1),traj_E(:,2));
plot(x_DP,y_DP);
plot(x_CBP,y_CBP);
legend("trajectory-E","trajectory-DP","trajectory-CBP")
title("trajectories under Vp=",int2str(Vu))
hold off
end

figure(2)
for i=1:3
    subplot(1,3,i)
    hold on
    plot(T_DP_all{i},R_DP_all{i});
    plot(T_CBP_all{i},R_CBP_all{i});
    legend("R for DP","R for CBP")
    Vu = Vui(i);
    title("R under Vp=",int2str(Vu))
    hold off
end

%%
%functions
function dy = deriv(t,y,VT,Vu,theta_E)
%y(1) = R, y(2) = beta
R = y(1);
beta = y(2);
dR = VT*cos(beta-theta_E)-Vu;
d_beta = -VT*sin(beta-theta_E)/R;
dy = [dR;d_beta];
end

function dR = CBP(t,R,VT,Vu,theta_E,theta,beta)
%y(1) = R, y(2) = beta
dR = VT*cos(beta-theta_E)-Vu*cos(beta-theta);
end

function [value, isterminal, direction] = StopEventPos(t, y, pos)
    value      = y(1) - pos;
    isterminal = 1;   % Stop the integration
    direction  = 0;
end