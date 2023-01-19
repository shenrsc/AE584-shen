clc;
clear all;
L1 = [0,0];
L2 = [4,2];
theta1 = -165/180*pi;
theta2 = 150/180*pi;
theta = 2*pi+theta1-theta2;
phi = -theta1+theta;
%pos = get_pos(theta1,theta2,L1,L2);
tt = fun_2a(L1,L2,[4,2],theta,phi);
fun = @(x) fun_2a(L1,L2,x,theta,phi);
fval_list = [];
x_all = [];
for i = -2:2:10
    for j = -2:2:10
x0 = [i,j];
options = optimoptions('fminunc','OptimalityTolerance',10e-6);
[x_ans,fval] = fminunc(fun,x0,options);
fval_list = [fval_list,fval];
x_all = [x_all;x_ans];
    end
end
fval_list = fval_list';
ind = find(fval_list==min(min(fval_list)));
x_final = x_all(ind,:);
hold on
plot([L1(1),L2(1)],[L1(2),L2(2)],'go')
plot(x_final(1),x_final(2),'ro')
axis([-2,6,-2,7])
title('positions')
legend("lighthouses","obtained location")