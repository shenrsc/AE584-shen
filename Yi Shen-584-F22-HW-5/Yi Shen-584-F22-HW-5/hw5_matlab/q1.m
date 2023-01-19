clc;
clear all;
VT = 5;
Vu = 6;
theta_E = pi/2;
time = 0:0.01:100;
finPos = 0;
opts = odeset('Events', @(t,y)StopEventPos(t,y,finPos), 'RelTol', 1e-6, 'AbsTol', 1e-6);
odefun = @(t,y) deriv(t,y,VT,Vu,theta_E);  % Anonymous derivative function with A
tspan = time;
f0 = [100;0];
[T,R_beta] = ode45(odefun,tspan,f0,opts);  % Pass in column vector initial value

len_tra = length(T);
traj_E = zeros(len_tra,2);
traj_E(:,1) = 100*ones(len_tra,1);
traj_E(:,2) = VT*T;

R =R_beta(:,1);
beta = R_beta(:,2);
x = traj_E(:,1)-R.*cos(beta);
y = traj_E(:,2)-R.*sin(beta);

figure(1)
hold on
plot(traj_E(:,1),traj_E(:,2));
plot(x,y);
title("trajectory of P(11m/s) and E(5m/s)")
legend("trajecotry of E","trajectory of P")

figure(2)
plot(T,R);
title("R versus time(P=6m/s)")

gama = Vu/VT;
d_beta = abs( (beta-pi/2).^(2-gama));
dd_beta = abs( (beta-pi/2).^(3-2*gama));
figure(3)
subplot(2,1,1)
plot(T(1:end-1),d_beta(1:end-1))
title("beta^* versus time(P=6m/s)")

subplot(2,1,2)
plot(T(1:end-1),dd_beta(1:end-1))
title("beta^{**} versus time(P=6m/s)")

function dy = deriv(t,y,VT,Vu,theta_E)
%direct DP
%y(1) = R, y(2) = beta
R = y(1);
beta = y(2);
dR = VT*cos(beta-theta_E)-Vu;
d_beta = -VT*sin(beta-theta_E)/R;
dy = [dR;d_beta];
end

function [value, isterminal, direction] = StopEventPos(t, y, pos)
    value      = y(1) - pos;
    isterminal = 1;   % Stop the integration
    direction  = 0;
end