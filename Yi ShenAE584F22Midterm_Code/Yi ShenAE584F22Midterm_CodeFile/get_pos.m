function pos = get_pos(theta1,theta2,L1,L2)
%from L1 and L2 to get the pos of P
x1 = L1(1);
y1 = L1(2);
x2 = L2(1);
y2 = L2(2);
T1 = tan(pi/2-theta1);
T2 = tan(pi/2-theta2);
M1 = [T1,-1; 
          T2,-1];
V2 = [T1*x1-y1; 
        T2*x2-y2];
pos = inv(M1)*V2;
end

