function dydt = vdp2(t,y)
S_inv = [1, sin(y(1))*tan(y(2)), cos(y(1))*tan(y(2));
            0,  cos(y(1)),                -sin(y(1));
            0,  sin(y(1))*sec(y(2)), cos(y(1))*sec(y(2));];
w = [cos(2*t), cos(2*t), 0.025*t]';

dydt = S_inv*w;
end

