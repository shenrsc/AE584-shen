clc;
clear all;
L1 = [0,0];
L2 = [5,5];
L3=[2.5,0];
R1=2.5;
R2=6;
R3=2;
fun = @(x) fun_3a(x,L1,L2,L3,R1,R2,R3);
x0 = [10,0];
options = optimoptions('fminunc','OptimalityTolerance',10e-6);
[x1,fval] = fminunc(fun,x0,options);
x0_2=[0,10];
[x2,fval] = fminunc(fun,x0_2,options);
p = -5:5:10;
q=10:-5:-5;
solutions = [];
for i=1:length(p)
    for j=1:length(q)
        dot = [p(i),q(j)];
        [sol,fval] = fminunc(fun,dot,options);
        solutions=[solutions;sol];
    end
end

theta = linspace(-pi,pi,1000);
circle1_x = L1(1)+R1*cos(theta);
circle1_y = L1(2)+R1*sin(theta);
circle2_x = L2(1)+R2*cos(theta);
circle2_y = L2(2)+R2*sin(theta);
c3_x = L3(1)+R3*cos(theta);
c3_y = L3(2)+R3*sin(theta);
figure(1)
hold all
plot(circle1_x,circle1_y);
plot(circle2_x,circle2_y);
plot(c3_x,c3_y);
scatter(solutions(:,1),solutions(:,2));

xlabel('x-axis')
ylabel('y-axis')
axis equal
legend('circle1','circle2','circlue3','fixed positions');
hold off