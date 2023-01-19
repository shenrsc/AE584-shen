function fun = fun_4(L1,L2,x,theta,phi1,star1,phi2,star2)

eq1 = dot(x-L1,L2-L1)+norm(x-L1)...
    *norm(x-L2)*cos(theta)-norm(x-L1)^2;
eq2 = dot(L2-x,star1)-cos(phi1)*norm(L2-x);
eq3 = dot(L2-x,star2)-cos(phi2)*norm(L2-x);
fun = eq1^2+eq2^2+eq3^2;
if(norm(x-L1)<0.1 || norm(x-L2)<0.1)
    fun = fun+10001/(norm(x-L1)*norm(x-L2)+0.01);
end
end

