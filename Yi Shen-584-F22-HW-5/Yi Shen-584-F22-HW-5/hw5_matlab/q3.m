clc;
clear all;
c0 = 0;
VT = 5;
Vu = 6;
theta_E = pi/2;
time = 0:0.01:100;
tspan = time;
theta = asin(VT/Vu);
finPos = 0;
opts = odeset('Events', @(t,y)StopEventPos(t,y,finPos), 'RelTol', 1e-6, 'AbsTol', 1e-6);
lambdas_1 = [0.25, 0.5, 0.75, 0.9];
lambdas_2 = [1, 2, 5, 50];
lambdas =  [0.25, 0.5, 0.75, 0.9, 1, 2, 5, 50];

xpos_PP_all = {};
ypos_PP_all = {};
x_CBP_all = {};
y_CBP_all = {};
traj_E1 = zeros(1,1);
traj_E2 = zeros(1,1);
R_PP_all = {};
R_CBP_all = {};

for i=1:length(lambdas)
    lambda = lambdas(i);
    %%
    %to calculate PP
    %beta_PP = 0;
    ode_PP = @(t,y) PP(t,y,VT,Vu,theta_E,lambda);
    y0 = [100;0];
    [T_PP,y_PP] = ode45(ode_PP,tspan,y0,opts);
    R =y_PP(:,1);
    R_PP_all{i} = R;
    beta = y_PP(:,2);
    len_tra_PP = length(T_PP);
    traj_E_PP = zeros(len_tra_PP,2);
    traj_E_PP(:,1) = 100*ones(len_tra_PP,1);
    traj_E_PP(:,2) = VT*T_PP;
    xpos_PP = traj_E_PP(:,1)-R.*cos(beta);
    ypos_PP = traj_E_PP(:,2)-R.*sin(beta);
    xpos_PP_all{i}=xpos_PP;
    ypos_PP_all{i}=ypos_PP;
    
    if(i<length(lambdas_1))
        if(length(traj_E_PP(:,1))>length(traj_E1(:,1)))
            traj_E1 = traj_E_PP;
        end
    else
        if(length(traj_E_PP(:,1))>length(traj_E2(:,1)))
            traj_E2 = traj_E_PP;
        end
    end
    
    %%
    %to calculate CBP
    beta_CBP = 0;
    ode_CBP = @(t,R) CBP(t,R,VT,Vu,theta_E,theta,beta_CBP);
    R0 = 100;
    [T_CBP,R_CBP] = ode45(ode_CBP,tspan,R0,opts);
    R_CBP_all{i} = R_CBP;
    len_tra_CBP = length(T_CBP);
    traj_E_CBP = zeros(len_tra_CBP,2);
    traj_E_CBP(:,1) = 100*ones(len_tra_CBP,1);
    traj_E_CBP(:,2) = VT*T_CBP;
    x_CBP = traj_E_CBP(:,1)-R_CBP.*cos(beta_CBP);
    y_CBP = traj_E_CBP(:,2)-R_CBP.*sin(beta_CBP);
    x_CBP_all{i} = x_CBP;
    y_CBP_all{i}=y_CBP;
    if(i<length(lambdas_1))
        if(length(traj_E_CBP(:,1))>length(traj_E1(:,1)))
            traj_E1 = traj_E_CBP;
        end
    else
        if(length(traj_E_CBP(:,1))>length(traj_E2(:,1)))
            traj_E2 = traj_E_CBP;
        end
    end

end

%%
%PP and CBP <1
figure(1) %trajectory
hold on
for i=1:length(lambdas_1)
    plot(xpos_PP_all{i},ypos_PP_all{i})
end
plot(traj_E1(:,1),traj_E1(:,2))
hold off
legend('traj \lambda=0.25','traj \lambda=0.5','traj \lambda=0.75','traj \lambda=0.9','traj of E')
title('trajectory for different P and E when \lambda<1')

figure(2) %R
hold on
for i=1:length(lambdas_1)
    plot((0:1:(length(R_PP_all{i})-1))/100 , R_PP_all{i});
end
hold off
legend('R(\lambda=0.25)','R (\lambda=0.5)','R (\lambda=0.75)','R (\lambda=0.9)')
title('R versus time when \lambda<1')


%%
%PP and CBP >1
figure(3) %trajectory
hold on
len = length(lambdas_1);
for i=len+1:1:len+length(lambdas_2)
    plot(xpos_PP_all{i},ypos_PP_all{i});
end
plot(x_CBP_all{i},y_CBP_all{i},'--');
plot(traj_E2(:,1),traj_E2(:,2))

legend('PP traj \lambda=1','PP traj \lambda=2',...
    'PP traj \lambda=5','PP traj \lambda=50',...
   'CBP traj', 'traj of E');
title('trajectory for different P and E when \lambda>1')
hold off


figure(4) %R
hold on
for i=len+1:1:len+length(lambdas_2)
    plot((0:1:(length(R_PP_all{i})-1))/100 , R_PP_all{i});
end
plot((0:1:(length(R_CBP_all{i})-1))/100,R_CBP_all{i},'--');
hold off
legend('R(\lambda=1)','R (\lambda=2)','R (\lambda=5)','R (\lambda=50)','R CBP')
title('R versus time when \lambda>1')


function dR = CBP(t,R,VT,Vu,theta_E,theta,beta)
dR = VT*cos(beta-theta_E)-Vu*cos(beta-theta);
end

function dy = PP(t,y,VT,Vu,theta_E,lambda)
%y(1) = R, y(2) = beta
R = y(1);
beta = y(2);
theta = lambda*beta;
d_R = VT*cos(beta-theta_E)-Vu*cos(beta-theta);
d_beta = -(VT*sin(beta-theta_E)-Vu*sin(beta-theta))/R;
dy = [d_R;d_beta];
end

function dy = deriv(t,y,VT,Vu,theta_E)
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