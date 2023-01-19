function dx  = dynsim(t,x,nzE)
% Returns xdot for dynamics engagement simulation.
% Takes evader normal acceleration as input
% Written by Syed Aseem Ul Islam (aseemisl@umich.edu) 
dx = zeros(8,1);
% x(1)    :: VP
% x(2)    :: gammaP
% x(3)    :: hP
% x(4)    :: dP
% x(5)    :: VE
% x(6)    :: gammaE
% x(7)    :: hE
% x(8)    :: dE
g = 9.81; %m/s^2
SP =2.3 ; %Reference area for drag calculations (pursuer)
SE = 28; %Reference area for drag calculations (evader)
mP =130 ; %mass of pursuer in kg
mE = 10000; %mass of evader in kg
%use Matlab function atmosisa to use ISA to compute speed of sound aP and air density rhoP at altitude hP
hP=x(3);
[~, aP, ~, rhoP] = atmosisa(hP);
%use Matlab function atmosisa to use ISA to compute speed of sound aE and air density  rhoE at altitude hE
hE = x(7);
[~, aE, ~, rhoE] = atmosisa(hE);
%use Matlab function atmosisa to use ISA to air density rho0 at sea level
[~,~, ~, rho0] = atmosisa(0);
MiP = [0 0.6 0.8 1 1.2 2 3 4 5]; %MP data points for pursuer Cd
CdiP = [0.016 0.016 0.0195 0.045 0.039 0.0285 0.024 0.0215 0.020]; %Cd data points for pursuer Cd
CdP = pchip(MiP,CdiP,x(1)/aP); % CdP at atltitude hP and Mach MP
MiE = [0 0.9 1 1.2 1.6 2 ]; %ME data points for evader Cd
CdiE = [0.0175 0.019 0.05 0.045 0.043 0.038]; %Cd data points for evader Cd
CdE = pchip(MiE,CdiE,x(5)/aE); % CdE at atltitude hE and Mach ME
TE =rhoE/rho0*76310; %Turbofan thrust approximation for evader in N
% Thrust profile for AIM120C5 pursuer
if 0<=t && t<10
    TP = 11000;
elseif 10<=t && t<30
    TP = 1800;
else
    TP = 0;
end
%TP =; %N
VP = x(1);
gammaP = x(2);
dP = x(4);
VE = x(5);
gammaE = x(6);
dE = x(8);
R = norm([hE-hP,dE-dP]);
Rdot = ((hE-hP)*(VE*sin(gammaE)-VP*sin(gammaP))...
    +(dE-dP)*(VE*cos(gammaE)-VP*cos(gammaP)))/R;
betadot = ((dE-dP)*(VE*sin(gammaE)-VP*sin(gammaP))...
    -(hE-hP)*(VE*cos(gammaE)-VP*cos(gammaP)))...
    /R^2;
% Pursuer normal acceleration (Gravity Corrected Proportional Guidance)
nzP = -3*abs(Rdot)*betadot-g*cos(gammaP);
% Saturate pursuer normal acceleration at 40g
if abs(nzP)>40*g
    nzP = sign(nzP)*40*g;
end
dx(1) = (TP-0.5*rhoP*VP^2*SP*CdP)/mP-g*sin(gammaP);
dx(2) = -1/VP*(nzP+g*cos(gammaP));
dx(3) = VP*sin(gammaP);
dx(4) = VP*cos(gammaP);
dx(5) = (TE-0.5*rhoE*VE^2*SE*CdE)/mE-g*sin(gammaE);
dx(6) = -1/VE*(nzE+g*cos(gammaE));
dx(7) = VE*sin(gammaE);
dx(8) = VE*cos(gammaE);
end