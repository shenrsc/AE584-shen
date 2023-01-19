clc;
clear all;
L1 = [0,0,0];
L2 = [5,0,0];
theta = 0.5*pi;
phi1 = 135/180*pi;
phi2 = 90/180*pi;
star1 = [0,1,0];
star2 = [0,0,1];

fun = @(x) fun_4(L1,L2,x,theta,phi1,star1,phi2,star2);
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


center = x_final;
house = [L1;L2];
x = house(:,1);
y = house(:,2);
z = house(:,3);
figure(1)
subplot(2,2,1)
scatter(x,z,50,'g','fill')
hold on
scatter(center(1), center(3),50,'r','fill')
hold off
grid on
ylabel('$z$ (m)','interpreter','latex','fontsize',15)
%xlabel('$x$ (m)','interpreter','latex','fontsize',15)
subplot(2,2,3)
scatter(x,y,50,'g','fill')
hold on
scatter(center(1), center(2),50,'r','fill')
hold off
grid on
ylabel('$y$ (m)','interpreter','latex','fontsize',15)
xlabel('$x$ (m)','interpreter','latex','fontsize',15)
subplot(2,2,4)
scatter(z,y,50,'g','fill')
hold on
scatter(center(3), center(2),50,'r','fill')
hold off
%ylabel('$y$ (m)','interpreter','latex','fontsize',15)
xlabel('$z$ (m)','interpreter','latex','fontsize',15)
grid on

