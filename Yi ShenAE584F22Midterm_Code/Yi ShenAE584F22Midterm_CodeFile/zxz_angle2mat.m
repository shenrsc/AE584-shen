function O_matrix = zxz_angle2mat(phi,theta,psi)
r1 = [cos(phi), sin(phi), 0;
         -sin(phi),  cos(phi),0;
         0,            0,           1];
r2 = [1,    0,  0;
         0, cos(theta),    sin(theta);
         0, -sin(theta),     cos(theta)];
r3 =  [cos(psi), sin(psi), 0;
         -sin(psi),  cos(psi),0;
         0,            0,           1];
O_matrix = r3*r2*r1;
end

