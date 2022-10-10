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
options = optimoptions('fminunc','OptimalityTolerance',10e-12);
[x1,fval_1] = fminunc(fun,x0,options);
x0_2=[0,10];
[x2,fval_2] = fminunc(fun,x0_2,options);
x0_2=[0,10];
p = -5:0.5:10;
q=10:-0.5:-5;
sols1 = [];
sols2 = [];
for i=1:length(p)
    for j=1:length(q)
        dot = [p(i),q(j)];
        [sol,fval] = fminunc(fun,dot,options);
        if(norm(sol-x1)<10e-6)
            sols1 = [sols1;dot];
        else
            sols2 = [sols2;dot];
        end
    end
end
hold all
scatter(sols1(:,1),sols1(:,2),[],'r');
scatter(sols2(:,1),sols2(:,2),[],'b');
xlabel('x-axis')
ylabel('y-axis')
axis equal
legend('converge to point1','converge to point2');