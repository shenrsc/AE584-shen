clc;
clear all;
L1 = [0,0];
L2 = [4,2];
L3 = [1,4];
theta1 = -140/180*pi;
theta2 = 90/180*pi;
theta3 = -30/180*pi;
pos1 = get_pos(theta1,theta2,L1,L2);
pos2 = get_pos(theta2,theta3,L2,L3);
pos3 = get_pos(theta1,theta3,L1,L3);
pos = [pos1, pos2,pos3];

hold on
plot([L1(1),L2(1),L3(1)],[L1(2),L2(2),L3(2)],'go')
plot(pos(1,:),pos(2,:),'bo')
plot(sum(pos(1,:))/3,sum(pos(2,:))/3,'ro')
axis([-2,6,-2,7])
title('positions')
legend("lighthouses","obtained location","three-cornered hat");