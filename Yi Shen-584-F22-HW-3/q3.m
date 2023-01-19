clc;
clear all;
L1 = [0,0,0];
L2 = [5,0,0];
theta = 0.5*pi;
phi = 135/180*pi;
%pos = get_pos(theta1,theta2,L1,L2);
fun = @(x) fun_3(L1,L2,x,theta,phi);
fval_list = [];
x_all = [];
for i = -5:2:5
    for j = -5:2:5
        for q = -5:2:5
x0 = [i,j,q];
options = optimoptions('fminunc','OptimalityTolerance',10e-16);
[x_ans,fval] = fminunc(fun,x0,options);
fval_list = [fval_list,fval];
x_all = [x_all;x_ans];
        end
    end
end
fval_list = fval_list';
ind = find(fval_list==min(min(fval_list)));
x_final = x_all(ind,:);


%3D plot
center = [2.5,2.5,0];
x = x_all(:,1);
y = x_all(:,2);
z = x_all(:,3);
figure(1)
scatter3(x,y,z,50,'b','fill')
hold on
scatter3(center(1), center(2), center(3),50,'r','fill')
hold off
zlabel('$z$ (m)','interpreter','latex','fontsize',15)
ylabel('$y$ (m)','interpreter','latex','fontsize',15)
xlabel('$x$ (m)','interpreter','latex','fontsize',15)

%2D projections

figure(2)
subplot(2,2,1)
scatter(x,z,50,'b','fill')
hold on
scatter(center(1), center(3),50,'r','fill')
hold off
grid on
ylabel('$z$ (m)','interpreter','latex','fontsize',15)
%xlabel('$x$ (m)','interpreter','latex','fontsize',15)
subplot(2,2,3)
scatter(x,y,50,'b','fill')
hold on
scatter(center(1), center(2),50,'r','fill')
hold off
grid on
ylabel('$y$ (m)','interpreter','latex','fontsize',15)
xlabel('$x$ (m)','interpreter','latex','fontsize',15)
subplot(2,2,4)
scatter(z,y,50,'b','fill')
hold on
scatter(center(3), center(2),50,'r','fill')
hold off
%ylabel('$y$ (m)','interpreter','latex','fontsize',15)
xlabel('$z$ (m)','interpreter','latex','fontsize',15)
grid on

figure(3)
[Xsp,Ysp,Zsp] = sphere;
surf(2.5.*Xsp+ 2.5,2.5.*Ysp,2.5.*Zsp,'FaceAlpha',0.25);
hold on
scatter3(x,y,z,50,'b','fill')
grid on
hold off
axis equal