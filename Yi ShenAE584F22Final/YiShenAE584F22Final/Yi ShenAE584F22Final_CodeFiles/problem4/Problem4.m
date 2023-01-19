% 584 Final Project 
% Problem 4
% Written by Syed Aseem Ul Islam (aseemisl@umich.edu)
clc

time = 50; %seconds
Ts = 0.1;

g = 9.81; %m/s^2
umax = 40*g; %Saturation limit of nzP for optimization

% x(1)    :: VP
% x(2)    :: gammaP
% x(3)    :: hP
% x(4)    :: dP
% x(5)    :: VE
% x(6)    :: gammaE
% x(7)    :: hE
% x(8)    :: dE

x0_dyn = [ 450 ; 0 ; 10000 ; 0 ; 450 ; 0 ; 10000 ; 6500 ]; %initial condition for engagement simulation
x1_dyn = [ 450 ; 0 ; 10000 ; 0 ; 350 ; 0.1 ; 10000 ; 9000 ]; %initial condition for engagement simulation
x2_dyn = [ 450 ; 0 ; 10000 ; 0 ; 350 ; -0.1 ; 10000 ; 8000 ]; %initial condition for engagement simulation
x3_dyn = [ 450 ; 0 ; 8000 ; 0 ; 350 ; -0.1 ; 10000 ; 6000 ]; %initial condition for engagement simulation
x4_dyn = [ 450 ; 0 ; 4000 ; 0 ; 350 ; 0.2 ; 6000 ; 2000 ]; %initial condition for engagement simulation
x5_dyn = [ 450 ; 0 ; 10000 ; 0 ; 350 ; 0.2 ; 6000 ; 2000 ]; %initial condition for engagement simulation
x6_dyn = [ 450 ; 0 ; 10000 ; 0 ; 400 ; 0 ; 7000 ; 5000 ]; %initial condition for engagement simulation
x7_dyn = [ 450 ; 0 ; 10000 ; 0 ; 400 ; 0.0 ; 12000 ; 6000 ]; %initial condition for engagement simulation
x8_dyn = [ 450 ; 0 ; 9000 ; 0 ; 400 ; -0.1 ; 12000 ; 6000 ]; %initial condition for engagement simulation
x9_dyn = [ 450 ; 0 ; 9000 ; 0 ; 320 ; -0.4 ; 12000 ; 7000 ]; %initial condition for engagement simulation

% Evader normal acceleration
nzE =-g;
x_dyn = [x0_dyn, x1_dyn, x2_dyn, x3_dyn, x4_dyn, x5_dyn, x6_dyn, x7_dyn, x8_dyn, x9_dyn];
% %%%%%%%%%%%%% i %%%%%%%%%%%%%%%%%
for i =1:10
    x0_dyn = x_dyn(:,i);
x1 = zeros(8,time/Ts);
nzP = zeros(1,time/Ts);
Rdot = zeros(1,time/Ts);

for ii = 1:time/Ts
    if ii == 1
        [~,xx]      = ode45(@(t,x)dynsim(t,x,nzE,0), [ii ii+1]*Ts , x0_dyn );
    else
        [~,xx]      = ode45(@(t,x)dynsim(t,x,nzE,nzP(ii-1)), [ii ii+1]*Ts , x1(:,ii-1) );
    end
    x1(:,ii) = xx(end,:);
    y = output( x1(:,ii) );
    
%     %%% Proportinal Guidance %%%%%%%%%%
%     nzP(:,ii) = -3*abs( y(2) )*y(3) - g*cos(x1(2,ii)) ;
%     %%% Proportinal Guidance %%%%%%%%%%

    %%% Custom Guidance %%%%%%%%%%
    dP = x1(4,ii);
    dE = x1(8,ii);
    hP = x1(3,ii);
    hE = x1(7,ii);
    angle = atan2(hE-hP,dE-dP);
    if(abs(angle)<0.001)
        angle =1.5;
    end
    if(abs(y(1))>3000)
        if(angle>0)
            n_zp = -3*abs( y(2) )*y(3) -9.81*cos(x1(2,ii))-200*angle;
        else
            n_zp = -3*abs( y(2) )*y(3) -9.81*cos(x1(2,ii));
        end
    elseif(abs(y(1))>1000)
        if(angle>0)
            n_zp = -3*abs( y(2) )*y(3) -9.81*cos(x1(2,ii))-100*angle;
        else
            n_zp = -3*abs( y(2) )*y(3) -9.81*cos(x1(2,ii));
        end
    else
        n_zp = -3*abs( y(2) )*y(3) -9.81*cos(x1(2,ii));
    end
    nzP(:,ii) = n_zp;
    %%% Custom Guidance %%%%%%%%%%

    %%% Intersample Fuzing %%%%%%%%
    [detonate , missDistance ] = fuze( xx ); %check for fuzing conditions in intersample xx
    if detonate
        missDistance
        break
    end
    %%% Intersample Fuzing %%%%%%%%
end




figure(i)
p1 = plot( x1(4,1:ii)/1000  , x1(3,1:ii)/1000  , 'b' );
hold on
plot( x1(4,1)/1000  , x1(3,1)/1000  , 'bx' )
plot( x1(4,ii)/1000  , x1(3,ii)/1000  , 'bo' )
p2 = plot( x1(8,1:ii)/1000  , x1(7,1:ii)/1000  , 'r' );
plot( x1(8,1)/1000  , x1(7,1)/1000  , 'rx' )
plot( x1(8,ii)/1000  , x1(7,ii)/1000  , 'ro' )
hold off
ylimits = ylim;
xlimits = xlim;
axis equal
xlim(xlimits)
ylim([0 ylimits(2)])
legend([p1,p2],{'Pursuer','Evader'},'interpreter','latex')
ylabel('$h$ (km)','interpreter','latex')
xlabel('$d$ (km)','interpreter','latex')
grid on
end

for ii = 1:time/Ts
    if ii == 1
        [~,xx]      = ode45(@(t,x)dyn_sim(t,x,nzE), [ii ii+1]*Ts , x0_dyn );
    else
        [~,xx]      = ode45(@(t,x)dyn_sim(t,x,nzE), [ii ii+1]*Ts , x1(:,ii-1) );
    end
    x1(:,ii) = xx(end,:);
    y = output( x1(:,ii) );
    
%     %%% Proportinal Guidance %%%%%%%%%%
%     nzP(:,ii) = -3*abs( y(2) )*y(3) - g*cos(x1(2,ii)) ;
%     %%% Proportinal Guidance %%%%%%%%%%

    %%% Custom Guidance %%%%%%%%%%
    %nzP(:,ii) = -6*g;
    %%% Custom Guidance %%%%%%%%%%

    %%% Intersample Fuzing %%%%%%%%
    [detonate , missDistance ] = fuze( xx ); %check for fuzing conditions in intersample xx
    if detonate
        missDistance
        break
    end
    %%% Intersample Fuzing %%%%%%%%
end


%{
figure(2)
p1 = plot( x1(4,1:ii)/1000  , x1(3,1:ii)/1000  , 'b' );
hold on
plot( x1(4,1)/1000  , x1(3,1)/1000  , 'bx' )
plot( x1(4,ii)/1000  , x1(3,ii)/1000  , 'bo' )
p2 = plot( x1(8,1:ii)/1000  , x1(7,1:ii)/1000  , 'r' );
plot( x1(8,1)/1000  , x1(7,1)/1000  , 'rx' )
plot( x1(8,ii)/1000  , x1(7,ii)/1000  , 'ro' )
hold off
ylimits = ylim;
xlimits = xlim;
axis equal
xlim(xlimits)
ylim([0 ylimits(2)])
legend([p1,p2],{'Pursuer','Evader'},'interpreter','latex')
ylabel('$h$ (km)','interpreter','latex')
xlabel('$d$ (km)','interpreter','latex')
grid on
title("gravity-corrected proportional guidance law")
%}
