clc;
clear all;
L1 = [0,0];
L2 = [5,5];
L3=[2.5,0];
R1=2.5;
R2=5;
R3=3;
fun = @(x) fun_3a(x,L1,L2,L3,R1,R2,R3);
x0 = [0,4];
options = optimoptions('fminunc','OptimalityTolerance',10e-6);
[x1,fval] = fminunc(fun,x0,options);

%{
theta = linspace(-pi,pi,1000);
circle1_x = L1(1)+R1*cos(theta);
circle1_y = L1(2)+R1*sin(theta);
circle2_x = L2(1)+R2*cos(theta);
circle2_y = L2(2)+R2*sin(theta);
c3_x = L3(1)+R3*cos(theta);
c3_y = L3(2)+R3*sin(theta);
figure(1)
hold all
plot(circle1_x,circle1_y,'b');
plot(circle2_x,circle2_y,'b');
plot(c3_x,c3_y,'b');
xlabel('x-axis')
ylabel('y-axis')
axis equal
%}

x_a=[];
far = [];
for a = 0.05:0.05:10
    most_dis = 0;
    x_a = [x_a,a];
    for i=1:1:100
        R1_new = R1+a*(rand(1)-0.5);
        R2_new = R2+a*(rand(1)-0.5);
        R3_new = R3+a*(rand(1)-0.5);
        fun = @(x) fun_3a(x,L1,L2,L3,R1_new,R2_new,R3_new);
        options = optimoptions('fminunc','OptimalityTolerance',10e-6);
        [x_new,fval] = fminunc(fun,x0,options);
        if(norm(x_new-x1)>most_dis)
            most_dis = norm(x_new-x1);
        end
    end
    far = [far;most_dis];
end


figure(1)
semilogy(x_a,far,'g','linewidth',1);
xlim([min(x_a),max(x_a)]);
xticks(1:2:max(x_a));
xlabel('value of snesor error');
ylabel('logarithmic position degrades');
grid on;

