function fun = fun_2a(x,L1,L2,R1,R2)
%FUN_2A 此处显示有关此函数的摘要
%   此处显示详细说明

fun = [(x(1)-L1(1))^2+(x(2)-L1(2))^2-R1^2;
    (x(1)-L2(1))^2+(x(2)-L2(2))^2-R2^2];
fun = norm(fun);
end

