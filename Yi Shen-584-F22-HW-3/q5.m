clc;
clear all;
L1 = [0,0,0];
L2 = [5,0,0];
star1 = [0,1,0];
star2 = [0,0,1];
time = 200;
x_final_list = zeros(time,3);

for t = 1:200
theta = (90+2*randn(1))/180*pi;
phi1 = (135++2*randn(1))/180*pi;
phi2 = (90+2*randn(1))/180*pi;
fun = @(x) fun_4(L1,L2,x,theta,phi1,star1,phi2,star2);
fval_list = [];
x_all = [];
for i = -1:3:5
    for j = -1:3:5
        for q = -1:3:5
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
x_final_list(t,:) = x_final;
end
L1 = [0,0,0];
L2 = [5,0,0];
center = [2.5,2.5,0];
house = [L1;L2];
x = x_final_list(:,1);
y = x_final_list(:,2);
z = x_final_list(:,3);

xh = house(:,1);
yh = house(:,2);
zh = house(:,3);


figure(1)
subplot(2,2,1)
scatter(x,z,50,'b','fill')
hold on
scatter(xh,zh,50,'g','fill')
scatter(center(1), center(3),50,'r','fill')
hold off
grid on
ylabel('$z$ (m)','interpreter','latex','fontsize',15)
%xlabel('$x$ (m)','interpreter','latex','fontsize',15)
subplot(2,2,3)
scatter(x,y,50,'b','fill')
hold on
scatter(xh,yh,50,'g','fill')
scatter(center(1), center(2),50,'r','fill')
hold off
grid on
ylabel('$y$ (m)','interpreter','latex','fontsize',15)
xlabel('$x$ (m)','interpreter','latex','fontsize',15)
subplot(2,2,4)
scatter(z,y,50,'b','fill')
hold on
scatter(zh,yh,50,'g','fill')
scatter(center(3), center(2),50,'r','fill')
hold off
%ylabel('$y$ (m)','interpreter','latex','fontsize',15)
xlabel('$z$ (m)','interpreter','latex','fontsize',15)
grid on

error_norm = zeros(length(x_final_list(:,1)),1);
for i=1:length(error_norm(:,1))
    error_norm(i) = norm(x_final_list(i,:)-center);
end

nbins = 20;
figure(2)
histogram(error_norm,nbins)
title("histogram of the position fix errors")
div = std(error_norm);
mean_error = mean(error_norm);
disp("deviation of error");
disp(div);
disp("mean of error");
disp(mean_error);
