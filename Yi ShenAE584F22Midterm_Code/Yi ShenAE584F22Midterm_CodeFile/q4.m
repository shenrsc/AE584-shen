clc;
clear all;
time = 0:0.01:20;
phi = pi/6;
g = 9.80665;

O_BA0 = [1,             0,          0;
                0,  cos(phi),   sin(phi);
                0,  -sin(phi),  cos(phi)];  % matrix initial value
v_0 = [0;cos(phi);sin(phi)];
r_0 = [1;0;0];
w_BA = [0;0;1];


opts = odeset('RelTol',1e-5,'AbsTol',1e-16);
odefun = @(t,y) deriv(t,y);  % Anonymous derivative function with A
tspan = time;
f0 = reshape(O_BA0,[1,9])';
f0 = [f0;r_0;v_0];
[T,F] = ode45(odefun,tspan,f0,opts);  % Pass in column vector initial value
%T = F';
O_BA = F(:,1:9);
O_BA = reshape(O_BA.',3,3,[]);  % Reshape the output as a sequence of 3x3 matrices
r_cw = F(:,10:12);

figure(1)
hold on
for i=1:3
    for j=1:3
        subplot(3,3,3*(i-1)+j);
        plot(T,squeeze(O_BA(i,j,:)));
        %plot(T,o_indexs_2(j,:),'b');
        txt = [int2str(3*(i-1)+j),'th value of O_{BA}'];
        title(txt);
        xlabel('time(s)')
    end
end
hold off

figure(2)
hold on
for i=1:3
    subplot(3,1,i);
    plot(T,r_cw(:,i));
    txt = [int2str(i),'th component of r'];
    title(txt);
    xlabel('time(s)')
end
hold off

figure(3)
plot3(r_cw(:,1),r_cw(:,2),r_cw(:,3));
title("3D trajectory of the center");
grid on;
axis equal;
xlabel("x")
zlabel("z")
ylabel("y")

function dy = deriv(t,y)
w_x = vec_to_mat([0;0;1]);
O_BA = reshape(y(1:9),size(w_x));  % Reshape input y into matrix
O_BA_diff = -w_x*O_BA;  % Do the matrix multiply
dy1 = reshape(O_BA_diff,[1,9])';  % Reshape output as a column vector
dr = y(13:15);% same as velocity

g = 9.80665;
phi = pi/6;

a_mean = [-1-g*sin(phi)*sin(t);
                 -g*sin(phi)*cos(t);
                 -g*cos(phi)];
dv = O_BA'*a_mean-[0;0;-g]; %acceleration
dy = [dy1;dr;dv];
end

