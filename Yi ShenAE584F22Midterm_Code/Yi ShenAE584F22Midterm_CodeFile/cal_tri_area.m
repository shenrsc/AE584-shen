function area = cal_tri_area(A1,A2,A3)
x1 = A1(1);
x2 = A2(1);
x3 = A3(1);

y1 = A1(2);
y2 = A2(2);
y3 = A3(2);
area = abs( (x1*(y2-y3)+x2*(y3-y1)+x3*(y1-y2))/2  );
end

