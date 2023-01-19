clc;
clear all;
L1 = [0,0];
L2 = [4,2];
L3 = [1,4];
theta1 = -140/180*pi;
theta2 = 90/180*pi;
theta3 = -30/180*pi;

theta = 2*pi+theta1-theta2;
theta_2 = 2*pi+theta3-theta2; % 3 and 2
theta_3 = -theta1+theta3; %1 and 3

phi = -theta1+theta; %1 and 2
phi_1 = theta2; %3 and 2
phi_2 = theta3;%1 and 3
tt = fun_2a(L1,L2,[4,2],theta,phi);
fun = @(x) fun_2a(L1,L2,x,theta,phi);
fun2 = @(x) fun_2a(L3,L2,x,theta_2,phi_1);
fun3 = @(x) fun_2a(L1,L3,x,theta_3,phi_2);
fval_list = [];
x_all = [];
fval_list2= [];
x_all2 = [];
fval_list3 = [];
x_all3 = [];
for i = -2:2:10
    for j = -2:2:10
x0 = [i,j];
options = optimoptions('fminunc','OptimalityTolerance',10e-6);
[x_ans,fval] = fminunc(fun,x0,options);
fval_list = [fval_list,fval];
x_all = [x_all;x_ans];

%3 and 2
[x_ans2,fval2] = fminunc(fun2,x0,options);
fval_list2 = [fval_list2,fval2];
x_all2 = [x_all2;x_ans2];

%1 and 3
[x_ans3,fval3] = fminunc(fun3,x0,options);
fval_list3 = [fval_list3,fval3];
x_all3 = [x_all3;x_ans3];

    end
end
fval_list = fval_list';
ind = find(fval_list==min(min(fval_list)));
x_final_1 = x_all(ind,:);

fval_list2 = fval_list2';
ind = find(fval_list2==min(min(fval_list2)));
x_final_2 = x_all2(ind,:);

fval_list3 = fval_list3';
ind = find(fval_list3==min(min(fval_list3)));
x_final_3 = x_all3(ind,:);

x_lists_all = [x_final_1;x_final_2;x_final_3];

hold on
plot([L1(1),L2(1),L3(1)],[L1(2),L2(2),L3(2)],'go')
plot(x_lists_all(:,1),x_lists_all(:,2),'bo')
plot(sum(x_lists_all(:,1))/3,sum(x_lists_all(:,2))/3,'ro')
axis([-2,6,-2,7])
title('positions')
legend("lighthouses","obtained location","three-cornered hat")