function matrix = vec_to_mat(w)
%VEC_TO_MAT 此处显示有关此函数的摘要
%   此处显示详细说明
wx = w(1);
wy = w(2);
wz = w(3);
matrix = [0,-wz,wy;wz,0,-wx;-wy,wx,0];

end

