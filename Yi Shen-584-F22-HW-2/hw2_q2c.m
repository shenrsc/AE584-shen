clc;
clear all;
L1 = [0,0];
L2 = [5,5];
R1=2.5;
R2=5;
fun = @(x) fun_2a(x,L1,L2,R1,R2);
x0 = [10,0];
options = optimoptions('fminunc','OptimalityTolerance',10e-11);
[x1,fval] = fminunc(fun,x0,options);
x0_2=[0,10];
[x2,fval2]=fminunc(fun,x0_2,options);
p = -5:0.5:10;
q=10:-0.5:-5;

up_one = [];
down_one = [];
local_opt= [];
cc = [];
for i=1:length(p)
    for j=1:length(q)
        dot = [p(i),q(j)];
        [x,fval] = fminunc(fun,dot,options);
        if(norm(x2-x)<10e-6)
            up_one = [up_one;dot];
        else if(norm(x1-x)<10e-6)
            down_one = [down_one;dot];
            else
                local_opt = [local_opt;dot];
            end
        end
    end
end
hold all
scatter(up_one(:,1),up_one(:,2),[],'r');
scatter(down_one(:,1),down_one(:,2),[],'b');
scatter(local_opt(:,1),local_opt(:,2),[],'g');
xlabel('x-axis')
ylabel('y-axis')
axis equal
legend('convert to up','convert to down','points local opt');