clc;
clear all;
load("rcwA.mat");

T = 0.01;
A = [eye(3), T*eye(3);
        zeros(3,3), eye(3)];
B = [T^2/2*eye(3);
        T*eye(3)];
g = 9.80665;
D1 = diag([0.1, 0.1 0.1]);
D2 = diag([0.1, 0.1 0.1]);
D3 = diag([0.005, 0.005, 0.005]);
phi = pi/6;
O_ba_0 = [1,0,0;
    0,  cos(phi),   sin(phi);
    0,  -sin(phi),  cos(phi)];
r_0 = [1,0,0]';
v_0 = [0,   cos(phi),   sin(phi)]';
O_k_all = zeros(3,3,2001);
O_k_all(:,:,1) = O_ba_0;
R = 0.001*eye(3);
Q = 10*eye(6);
P_all = zeros(6,6,2001);
P_all(:,:,1) = 10*eye(6);
x_k_all = zeros(6,2001);
x_k_all(:,1) = [r_0;v_0];
C = [eye(3), zeros(3,3)];
Tmocap = 1;

y_k1 = rcwA_Ts_0_01(:,1);
for k = 1:1:2000
    if(mod((k+1)*T,Tmocap)==0)
        Ck1=C;
        y_k1 = rcwA_Ts_0_01(:,k+1)+D3*normrnd(0,1,[3,1]);
    else
        Ck1 = zeros(3,6);
    end
    w_k = [0,0,1]'+D1*normrnd(0,1,[3,1]);
    a_k = [-1-g*sin(phi)*sin(k*T);
                -g*sin(phi)*cos(k*T);
                -g*cos(phi)]+D2*normrnd(0,1,[3,1]);
    O_k1 = expm(-T*vec_to_mat(w_k)) *O_k_all(:,:,k);
    O_k_all(:,:,k+1)=O_k1;
    x_k_k = x_k_all(:,k);
    x_k1_k = A*x_k_k+B*(O_k1'*a_k-[0,0,-g]');
    Pkk = P_all(:,:,k);
    P_k1_k = A*Pkk*A'+Q;
    Kk = P_k1_k*Ck1'*inv(Ck1*P_k1_k*Ck1'+R);
    P_k1_k1 = P_k1_k-Kk*Ck1*P_k1_k;
    x_k1_k1 = x_k1_k+Kk*(y_k1-Ck1*x_k1_k);
    x_k_all(:,k+1)=x_k1_k1;
end
x_t_1 = x_k_all;

Tmocap = 0.1;
y_k1 = rcwA_Ts_0_01(:,1);
for k = 1:1:2000
    if(mod((k+1)*T,Tmocap)==0)
        Ck1=C;
        y_k1 = rcwA_Ts_0_01(:,k+1)+D3*normrnd(0,1,[3,1]);
    else
        Ck1 = zeros(3,6);
    end
    w_k = [0,0,1]'+D1*normrnd(0,1,[3,1]);
    a_k = [-1-g*sin(phi)*sin(k*T);
                -g*sin(phi)*cos(k*T);
                -g*cos(phi)]+D2*normrnd(0,1,[3,1]);
    O_k1 = expm(-T*vec_to_mat(w_k)) *O_k_all(:,:,k);
    O_k_all(:,:,k+1)=O_k1;
    x_k_k = x_k_all(:,k);
    x_k1_k = A*x_k_k+B*(O_k1'*a_k-[0,0,-g]');
    Pkk = P_all(:,:,k);
    P_k1_k = A*Pkk*A'+Q;
    Kk = P_k1_k*Ck1'*inv(Ck1*P_k1_k*Ck1'+R);
    P_k1_k1 = P_k1_k-Kk*Ck1*P_k1_k;
    x_k1_k1 = x_k1_k+Kk*(y_k1-Ck1*x_k1_k);
    x_k_all(:,k+1)=x_k1_k1;
end

figure(1)
hold on
plot3(rcwA_Ts_0_01(1,:),rcwA_Ts_0_01(2,:),rcwA_Ts_0_01(3,:));
plot3(x_t_1(1,:),x_t_1(2,:),x_t_1(3,:),'g');
plot3(x_k_all(1,:),x_k_all(2,:),x_k_all(3,:),'r');
hold off
axis equal;
xlabel("x");
ylabel("y");
zlabel("z");
legend("reference trajectory","T_{mocap}=1 estimated trajectory","T_{mocap}=0.1 estimated trajectory");


figure(2)
for i=1:1:3
    subplot(3,1,i)
    hold on
    plot(0:0.01:20,rcwA_Ts_0_01(i,:));
    plot(0:0.01:20,x_t_1(i,:),'g');
    plot(0:0.01:20,x_k_all(i,:),'r');
    hold off
    legend("reference","T_{mocap}=1","T_{mocap}=0.1");
    if(i==1)
        st = "trajectory versus time x-axis";
    elseif(i==2)
        st = "trajectory versus time y-axis";
    else
        st = "trajectory versus time z-axis"; 
    end
    title(st);
    xlabel("time(s)");
end

function matrix = vec_to_mat(w)
wx = w(1);
wy = w(2);
wz = w(3);
matrix = [0,-wz,wy;wz,0,-wx;-wy,wx,0];
end