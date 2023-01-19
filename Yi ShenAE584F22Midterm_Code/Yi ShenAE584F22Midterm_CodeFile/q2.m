clc;
clear all;
load('AE584_Midterm_P2.mat');
L1 = [1.52,0,0]';
L2 = [0,0,0]';
star1 = [0,1,0]';
star2 = [0,0,1]';
P0 = [0.52 0 -1]';
P_all = zeros(3,length(bearingL2St1));
P_all(:,1) = P0;
time = 0:1:length(bearingL2St1);
for i=1:length(bearingL2St1)
    theta = subAngL1L2(i);
    phi1 = bearingL2St1(i);
    phi2 = bearingL2St2(i);
    P0 = [0.52 0 -1]';
    fun = @(x) two_star_one_angle(L1,L2,x,theta,phi1,star1,phi2,star2);
    x0 = P_all(:,i);
    options = optimoptions('fminunc','OptimalityTolerance',10e-16);
    [x_ans,fval] = fminunc(fun,x0,options);
    P_all(:,i+1)=x_ans;
end
figure(1)
subplot(3,1,1)
plot(time,P_all(1,:));
title("position of spacecraft versus time on x-axis");
xlabel("time");
ylabel("position(AU)");

subplot(3,1,2)
plot(time,P_all(2,:));
title("position of spacecraft versus time on y-axis");
xlabel("time");
ylabel("position(AU)");

subplot(3,1,3)
plot(time,P_all(3,:));
title("position of spacecraft versus time on z-axis");
xlabel("time");
ylabel("position(AU)");

figure(2)
hold on
scatter3(P_all(1,:),P_all(2,:),P_all(3,:),'filled');
scatter3(L1(1),L1(2),L1(3),'filled','r');
scatter3(L2(1),L2(2),L2(3),'filled','y');
hold off
title("3D plot of stars and spacecraft trajectory");
legend("spacecraft trajectory","Mar","Sun");

