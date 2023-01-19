clc;
clear all;
L1 = [0,0];
L2 = [4,2];
theta1 = -165/180*pi;
theta2 = 150/180*pi;
pos = get_pos(theta1,theta2,L1,L2);

hold on
plot([L1(1),L2(1)],[L1(2),L2(2)],'go')
plot(pos(1),pos(2),'ro')
axis([-2,6,-2,7])
title('positions')
legend("lighthouses","obtained location")