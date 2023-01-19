function O_matrix = zyz_angle2mat(phi,theta,psi)
r1 = [cos(phi), -sin(phi), 0;
         sin(phi),  cos(phi),0;
         0,            0,           1];
r2 = [cos(theta),  0,  sin(theta);
          0,1,0;
          -sin(theta),  0,  cos(theta)];
r3 =  [cos(psi), -sin(psi), 0;
         sin(psi),  cos(psi),0;
         0,            0,           1];
O_matrix = r3*r2*r1;
end

