clc;
clear all;
time = 0:0.01:10;
phi_E = 0;
theta_E = pi/6;
psi_E = 0;
%[~,phi_e] = ode45(@(t,phi) sin(0.05*t), time, phi_E);
%[~,theta_e] = ode45(@(t,theta) 0.3*cos(0.01*t), time, theta_E);
%[~,psi_e] = ode45(@(t,psi) 0.5*sin(0.01*t), time, psi_E);
phi_e = 20 * (1-cos(0.05*time));
theta_e=  30*sin(0.01*time) + pi/6;
psi_e = 50*(1-cos(0.01*time));

O_EI = zeros(3,3,length(0:0.01:10));
for i = 1:1:length(0:0.01:10)
    O_EI(:,:,i) = zxz_angle2mat(phi_e(i),theta_e(i),psi_e(i));
end
%A = vec_to_mat(w0);  % Some arbitrary matrix we will use
F0 = eye(3);  % matrix initial value
odefun = @(t,y) deriv(t,y);  % Anonymous derivative function with A
tspan = 0:0.01:10;
f0 = reshape(F0,[1,9])';
[T,F] = ode45(odefun,tspan,f0);  % Pass in column vector initial value
F = reshape(F.',3,3,[]);  % Reshape the output as a sequence of 3x3 matrices
O_BI = F;

O_BE = zeros(3,3,length(0:0.01:10));
for i = 1:1:length(0:0.01:10)
   O_BE(:,:,i) = O_BI(:,:,i)*O_EI(:,:,i)';
end

figure(1)
hold on
for i=1:3
    for j=1:3
        subplot(3,3,3*(i-1)+j);
        plot(T,squeeze(O_BE(i,j,:)),'color','#D95319','LineWidth',2);
        %plot(T,o_indexs_2(j,:),'b');
        txt = [int2str(3*(i-1)+j),'th value of O_{BE}'];
        title(txt);
        xlabel('time(s)')
    end
end
hold off

O1_solutions = zeros(6,length(O_BE(1,1,:)));
for i=1:length(O_BE)
    [O1_solutions(1:3,i),O1_solutions(4:6,i)] = cal_Eular(O_BE(:,:,i));
end

T = 0:0.01:10;

figure(2)
subplot(3,1,1);
hold on
plot(T,O1_solutions(1,:),'color','#D95319','LineWidth',2);
title('phi versus time');
xlabel('time(s)');
hold off

subplot(3,1,2);
hold on
plot(T,O1_solutions(2,:),'color','#D95319','LineWidth',2);
title('theta versus time');
xlabel('time(s)')
hold off

subplot(3,1,3);
hold on
plot(T,O1_solutions(3,:),'color','#D95319','LineWidth',2);
title('psi versus time');
xlabel('time(s)')
hold off



function dy = deriv(t,y)
A = vec_to_mat([cos(2*t),cos(2*t),0.025*t]);
F = reshape(y,size(A));  % Reshape input y into matrix
FA = -A*F;  % Do the matrix multiply
dy = reshape(FA,[1,9])';  % Reshape output as a column vector
end
