clc;
clear all;
L1 = [0,0];
L2 = [5,5];
R1=2.5;
R2=5;
fun = @(x) fun_2a(x,L1,L2,R1,R2);
x0 = [10,0];
options = optimoptions('fminunc','OptimalityTolerance',10e-6);
[x1,fval] = fminunc(fun,x0,options);
x0_2=[0,10];
[x2,fval2]=fminunc(fun,x0_2,options);

theta = linspace(-pi,pi,1000);
circle1_x = L1(1)+R1*cos(theta);
circle1_y = L1(2)+R1*sin(theta);
circle2_x = L2(1)+R2*cos(theta);
circle2_y = L2(2)+R2*sin(theta);
figure(1)
hold on
plot(circle1_x,circle1_y);
plot(circle2_x,circle2_y);
plot(x1(1),x1(2),'Marker','*');
plot(x2(1),x2(2),'Marker','*');
xlabel('x-axis')
ylabel('y-axis')
axis equal
legend('circle1','circle2','solution1','solution2');
hold off