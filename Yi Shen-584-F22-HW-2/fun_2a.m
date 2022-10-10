function fun = fun_2a(x,L1,L2,R1,R2)

fun = [(x(1)-L1(1))^2+(x(2)-L1(2))^2-R1^2;
    (x(1)-L2(1))^2+(x(2)-L2(2))^2-R2^2];
fun = fun(1)^2+fun(2)^2;
end

