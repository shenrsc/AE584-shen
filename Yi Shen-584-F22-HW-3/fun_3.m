function fun = fun_3(L1,L2,x,theta,phi)

eq1 = dot(x-L1,L2-L1)+norm(x-L1)...
    *norm(x-L2)*cos(theta)-norm(x-L1)^2;
eq2 = dot(L2-x,[0,1,0])-cos(phi)*norm(L2-x);
fun = eq1^2+eq2^2;
%if(norm(x-L1)<0.1 || norm(x-L2)<0.1)
    %fun = fun+10001/(norm(x-L1)*norm(x-L2)+0.01);
%end
end

