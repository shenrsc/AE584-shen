function [solution1, solution2] = cal_Eular(o_matrix)
%get orientation_matrix in, Eular angles out
    theta_1 = -asin(o_matrix(1,3));
    theta_2 = pi-theta_1;
    if(theta_1<0)
        theta_2 = -pi-theta_1;
    end

    Psi_1 = atan2(o_matrix(1,2)/cos(theta_1),...
        o_matrix(1,1)/cos(theta_1));
    Psi_2 = atan2(o_matrix(1,2)/cos(theta_2),...
        o_matrix(1,1)/cos(theta_2));

    Phi_1 = atan2(o_matrix(2,3)/cos(theta_1),...
        o_matrix(3,3)/cos(theta_1));
    Phi_2 = atan2(o_matrix(2,3)/cos(theta_2),...
        o_matrix(3,3)/cos(theta_2));

    solution1 = [Phi_1,theta_1,Psi_1];
    solution2 = [Phi_2,theta_2,Psi_2];

end

