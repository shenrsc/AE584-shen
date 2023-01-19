clc;
clear all;
Lams = [3,4,5];
t = 0:0.001:9.999;
tf_star = 10;
T = 0.001;
opts = odeset( 'RelTol', 1e-6, 'AbsTol', 1e-6);

figure(1)
hold on
for i=1:length(Lams)
    lam = Lams(i);
    ode_p = @(t,p) deriv_p(t,p,lam,tf_star,T);
    tp = 9.999-t;
    p0 = [1;0];
    [T_P,p] = ode45(ode_p,tp,p0,opts);
    p_tao = flip(p); %from zeros to tf*
    tao = flip(T_P); %from zeros to tf*
    G_tf_tao = lam*p_tao(:,2)./(T*(tf_star-tao));
    TG_minus = -T*G_tf_tao; %from zeros to tf*
    %flip(TG_minus);
    x_axis = (tf_star-tao)/T;
    plot(x_axis(1:end-1),TG_minus(1:end-1));
end
hold off
legend('\Lambda=3','\Lambda=4','\Lambda=5');
xlim([0,10]);
title('-TG(t_f,t) versus (t_f-t)/T')

function dp = deriv_p(t,p,lam,tf_star,T)
    p1 = p(1);
    p2 = p(2);
    dp1 = lam/(T*(tf_star-t))*p2;
    dp2 = -p1+p2/T;
    dp = [dp1;dp2];
end