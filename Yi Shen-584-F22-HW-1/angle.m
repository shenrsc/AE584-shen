function o_matrix = angle(a,b,c)

o_matrix = [cos(b)*cos(c), cos(b)*sin(c), -sin(b);...
    cos(c)*sin(a)*sin(b)-cos(a)*sin(c), cos(a)*cos(c)+sin(a)*sin(b)*sin(c), cos(b)*sin(a);...
    sin(a)*sin(c)+cos(a)*cos(c)*sin(b), cos(a)*sin(b)*sin(c)-cos(c)*sin(a), cos(a)*cos(b)];
end

