clc;
clear all;
%from a and b import Orientation matrix
O_1 = load("O_matrix.mat");
O_2 = load("O_matrix_2.mat");
O_matrix_1 = O_1.O_matrix_1;
O_matrix_2 = O_2.F;
%then use cal_Eular fuction to calculate the angles
O1_solutions = zeros(6,length(O_matrix_1(1,1,:)));
O2_solutions = zeros(6,length(O_matrix_2(1,1,:)));
for i=1:length(O_matrix_1)
    [O1_solutions(1:3,i),O1_solutions(4:6,i)] = cal_Eular(O_matrix_1(:,:,i));
    [O2_solutions(1:3,i),O2_solutions(4:6,i)] = cal_Eular(O_matrix_2(:,:,i));
end

T = 0:0.01:10;



figure(1)
subplot(1,3,1);
hold on
plot(T,O2_solutions(1,:),'LineWidth',2);
plot(T,O1_solutions(1,:),'color','#D95319','LineStyle','--','LineWidth',2);
title('phi versus time');
xlabel('time(s)');
hold off

subplot(1,3,2);
hold on
plot(T,O2_solutions(2,:),'LineWidth',2);
plot(T,O1_solutions(2,:),'color','#D95319','LineStyle','--','LineWidth',2);
title('theta versus time');
xlabel('time(s)')
hold off

subplot(1,3,3);
hold on
plot(T,O2_solutions(3,:),'LineWidth',2);
plot(T,O1_solutions(3,:),'color','#D95319','LineStyle','--','LineWidth',2);
title('psi versus time');
xlabel('time(s)')
hold off


%----------------------------------------
figure(2)
subplot(1,3,1);
hold on
plot(T,O2_solutions(4,:),'LineWidth',2);
plot(T,O1_solutions(4,:),'color','#D95319','LineStyle','--','LineWidth',2);
title('phi versus time');
xlabel('time(s)');
hold off

subplot(1,3,2);
hold on
plot(T,O2_solutions(5,:),'LineWidth',2);
plot(T,O1_solutions(5,:),'color','#D95319','LineStyle','--','LineWidth',2);
title('theta versus time');
xlabel('time(s)')
hold off

subplot(1,3,3);
hold on
plot(T,O2_solutions(6,:),'LineWidth',2);
plot(T,O1_solutions(6,:),'color','#D95319','LineStyle','--','LineWidth',2);
title('psi versus time');
xlabel('time(s)')
hold off
%then plot 


