clc;
clear all;
theta1 = atan(2.5/2)-pi;
theta2 = pi/2;
theta3 =-atan(1.5/2);
theta_all = [theta1;theta2;theta3];
L1 = [0,0];
L2 = [4,2];
L3 = [1,4];
pos1 = get_pos(theta1,theta2,L1,L2);
pos2 = get_pos(theta2,theta3,L2,L3);
pos3 = get_pos(theta1,theta3,L1,L3);
Px = (pos1(1)+pos2(1)+pos3(1))/3;
Py = (pos1(2)+pos2(2)+pos3(2))/3;
p = [Px,Py];

len_each = 100000;
percentage = zeros(1,10);
dis = zeros(10,len_each);
for j = 1:1:10
    sigma = j/10;
    inside_times = 0;
    for i=1:1:len_each
        noised_theta = theta_all+normrnd(0,sigma,[3,1]);
        %get 3 potential pos
        pos12 = get_pos(noised_theta(1),noised_theta(2),L1,L2);
        pos23 = get_pos(noised_theta(2),noised_theta(3),L2,L3);
        pos13 = get_pos(noised_theta(1),noised_theta(3),L1,L3);
        c_x = (pos12(1)+pos23(1)+pos13(1))/3;
        c_y =  (pos12(2)+pos23(2)+pos13(2))/3;
        c_hat = [c_x,c_y];
        S_all = cal_tri_area(pos12,pos23,pos13);
        S1 = cal_tri_area(p,pos23,pos13);
        S2 = cal_tri_area(pos12,p,pos13);
        S3 = cal_tri_area(pos12,pos23,p);
        if(abs(S_all-(S1+S2+S3))<10e-6)
            inside_times = inside_times+1;
        end
        dis(j,i) = norm(c_hat-p);
    end
    percentage(j) = inside_times/len_each;
end
mean_dis = mean(dis,2);
figure(1)
plot(0.1:0.1:1,percentage);
xlabel("sigma");
ylabel("percentage of times");
title("percentage of times that P was inside the triangle versus sigma");

figure(2)
plot(0.1:0.1:1,mean_dis);
xlabel("sigma");
ylabel("average dis from p to chat");
title("average distance of P to chat versus sigma");

