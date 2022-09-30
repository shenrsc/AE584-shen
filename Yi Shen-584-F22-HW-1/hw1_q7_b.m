clc;
clear all;
w0 = [1,1,0]';
%A = vec_to_mat(w0);  % Some arbitrary matrix we will use
F0 = angle(0,0,0);  % matrix initial value
F1=[1,2,3;4,5,6;7,8,9];
odefun = @(t,y) deriv(t,y);  % Anonymous derivative function with A
tspan = 0:0.01:10;
f0 = reshape(F0,[1,9])';
f1 = reshape(F1,[1,9])';
[T,F] = ode45(odefun,tspan,f0);  % Pass in column vector initial value
%T = F';
F = reshape(F.',3,3,[]);  % Reshape the output as a sequence of 3x3 matrices

o_indexs_2 = zeros(9,length(T));
for i=1:length(T)
    o_matrix_t_2 = F(:,:,i)';
    for j=1:9
        o_indexs_2(j,i) = o_matrix_t_2(j);
    end
end

last_method = load("O_matrix.mat");
o_indexs_1 = last_method.o_indexs;

figure(1)
hold on
for j=1:9
    subplot(3,3,j);
    hold on
    
    plot(T,o_indexs_2(j,:),'b','LineWidth',2);
    plot(T,o_indexs_1(j,:),'color','#D95319','LineStyle','--','LineWidth',2);
    hold off
    legend('in b','in a');
    %plot(T,o_indexs_2(j,:),'b');
    txt = [int2str(j),'th value of O-matrix'];
    title(txt);
    xlabel('time(s)')
end
hold off
save("O_matrix_2.mat","F");



function dy = deriv(t,y)
A = vec_to_mat([cos(2*t),cos(2*t),0.025*t]);
F = reshape(y,size(A));  % Reshape input y into matrix
FA = -A*F;  % Do the matrix multiply
dy = reshape(FA,[1,9])';  % Reshape output as a column vector
end

