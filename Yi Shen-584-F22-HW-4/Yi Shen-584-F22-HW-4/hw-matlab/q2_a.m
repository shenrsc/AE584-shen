clc;
clear all;
load("rcwA.mat");
%plot3(rcwA_Ts_0_01(1,:),rcwA_Ts_0_01(2,:),rcwA_Ts_0_01(3,:));
T = 0.01;
A = [eye(3), T*eye(3);
        zeros(3,3), eye(3)];
B = [T^2/2*eye(3);
        T*eye(3)];
g = 9.80665;
D1 = diag([0.1, 0.1 0.1]);
D2 = diag([0.1, 0.1 0.1]);
phi = pi/6;
O_ba_0 = [1,0,0;
    0,  cos(phi),   sin(phi);
    0,  -sin(phi),  cos(phi)];
r_0 = [1,0,0]';
v_0 = [0,   cos(phi),   sin(phi)]';
O_k_all = zeros(3,3,2001);
O_k_all(:,:,1) = O_ba_0;
x_k_all = zeros(6,2001);
x_k_all(:,1) = [r_0;v_0];

for k = 1:1:2000
    w_k = [0,0,1]'+D1*normrnd(0,1,[3,1]);
    a_k = [-1-g*sin(phi)*sin(k*T);
                -g*sin(phi)*cos(k*T);
                -g*cos(phi)]+D2*normrnd(0,1,[3,1]);
    O_k1 = expm(-T*vec_to_mat(w_k)) *O_k_all(:,:,k);
    O_k_all(:,:,k+1)=O_k1;
    x_k = x_k_all(:,k);
    x_k1 = A*x_k+B*(O_k1'*a_k-[0,0,-g]');
    x_k_all(:,k+1)=x_k1;
end

figure(1)
hold on
plot3(rcwA_Ts_0_01(1,:),rcwA_Ts_0_01(2,:),rcwA_Ts_0_01(3,:));
plot3(x_k_all(1,:),x_k_all(2,:),x_k_all(3,:));
hold off
legend("reference trajectory","estimated trajectory");

function matrix = vec_to_mat(w)
wx = w(1);
wy = w(2);
wz = w(3);
matrix = [0,-wz,wy;wz,0,-wx;-wy,wx,0];
end