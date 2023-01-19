clc;
clear all;

%%
%init parameters
p0 = 0.001;
X_all_all = {};
P_all_all = {};
for scale = 1:1:4
    p0 = p0*10;
    Q = 0;
    R = 0.1*eye(3);
    X_0 =[3;3];
    D = diag([0.1,0.1,0.1]);
    X_all = zeros(2,51);
    X_all(:,1) = X_0;
    A = eye(2);
    L1 = [0;0];
    L2 = [5;5];
    L3 = [2.5;0];
    P_true = [0.7212; 2.4080];

    P_0_0 = p0*eye(2);

    %%
    %iternation parameters
    P_all = zeros(2,2,51);
    P_all(:,:,1) = P_0_0;
    y = zeros(3,51);
    l_y = zeros(3,51);

    %%
    %kalman filter
    for k = 1:1:50
        w_k = normrnd(0,1,[3,1]);
        x_k_k = X_all(:,k);
        x_k1_k = A*x_k_k;
        y_k1 = [2.5;
                   5;
                    3]+D*w_k;
        y(:,k) = y_k1;
        P_k_k = P_all(:,:,k);
        P_k1_k = A*P_k_k*A'+Q;
        C_k1 = linerity(x_k1_k,L1,L2,L3);
        Kk = P_k1_k*C_k1'/(C_k1*P_k1_k*(C_k1')+R);
        P_k1_k1 = P_k1_k-Kk*C_k1*P_k1_k;
        l_y(:,k) = measure(x_k1_k,L1,L2,L3);
        x_k1_k1 = x_k1_k+Kk*(y_k1-l_y(:,k));
        
        P_all(:,:,k+1) = P_k1_k1;
        X_all(:,k+1) = x_k1_k1;
    end
    X_all_all{end+1} = X_all;
    P_all_all{end+1} = P_all;
    
end

figure(1)
hold on
for i = 1:1:length(X_all_all)
    X_all = X_all_all{i};
    plot(X_all(1,:),X_all(2,:));
end
plot(P_true(1),P_true(2),'ro');
legend("p0=0.01","p0=0.1","p0=1","p0=10","true place of P");
title("trajectory of x");
hold off

figure(2)
p_norm = zeros(4,51);
tt = 0:1:50;
for j = 1:1:length(P_all_all)
    P_all = P_all_all{j};
    for i=1:51
        p_norm(j,i) = norm(P_all(:,:,i),'fro');
    end
end
semilogy(tt,p_norm(1,:));
hold all
semilogy(tt,p_norm(2,:));
semilogy(tt,p_norm(3,:));
semilogy(tt,p_norm(4,:));
legend("p0=0.01","p0=0.1","p0=1","p0=10");
title("frobenius norm of Pk|k versus k");
grid on

%%
%linerity function for  EKF
function C_k1 = linerity(xk,L1,L2,L3)
    C_k1 = [(xk-L1)'/norm(xk-L1);
                 (xk-L2)'/norm(xk-L2);
                 (xk-L3)'/norm(xk-L3)];
end

function g_x = measure(xk,L1,L2,L3)
    g_x = [norm(xk-L1);
                norm(xk-L2);
                norm(xk-L3)];

end