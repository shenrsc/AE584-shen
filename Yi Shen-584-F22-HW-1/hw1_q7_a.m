clc;
clear all;
time = 0:0.01:10;
[t,y] = ode45(@vdp2,time,[0;0;0]);
%y(1) = phi, y(2) = theta, y(3) = psi
w = [cos(2*t),cos(2*t),0.025*t];

figure(1)
title('w versus time')
hold on
plot(t,w(:,1),'b');
plot(t,w(:,2),'g');
plot(t,w(:,3),'r');
hold off
legend('wx','wy','wz');
xlabel('time')
ylabel('rotation velocity')

figure(2)
title('angles versus time')
hold on
plot(t,y(:,1),'b');
plot(t,y(:,2),'g');
plot(t,y(:,3),'r');
hold off
legend('phi','theta','psi');
xlabel('time')
ylabel('angles in radian')

O_matrix_1 = zeros(3,3,1001);
o_indexs = zeros(9,length(t));
for i=1:length(t)
    ang = y(i,:);
    o_matrix_t = angle(ang(1),ang(2),ang(3))';
    o_matrix =  o_matrix_t';
    O_matrix_1(:,:,i) = o_matrix;
    for j=1:9
        o_indexs(j,i) = o_matrix_t(j);
    end
end

figure(3)
hold on
for j=1:9
    subplot(3,3,j);
    plot(t,o_indexs(j,:));
    txt = [int2str(j),'th value of O-matrix'];
    title(txt);
    xlabel('time(s)')
end
hold off
save("O_matrix.mat","o_indexs","O_matrix_1","y");

