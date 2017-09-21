syms q1 q2 q3 l1 l2 l3;

% order: delta, theta, radius, alpha:
dh1 = [90, 0,  0, -90];
dh2 = [0,  0,  166,  0];
dh3 = [0,  90, 200, 0];
d1 = dh1(1);
t1 = dh1(2);
t1 = deg2rad(t1);
r1 = dh1(3);
a1 = dh1(4);
a1 = deg2rad(a1);
d2 = dh2(1);
t2 = dh2(2);
t2 = deg2rad(t2);
r2 = dh2(3);
a2 = dh2(4);
a2 = deg2rad(a2);
d3 = dh3(1);
t3 = dh3(2);
t2 = deg2rad(t2);
r3 = dh3(3);
a3 = dh3(4);
a3 = deg2rad(a3);
    syms symt symd symr syma q1 q2 q3 real;
    A = [ cos(symt) -sin(symt)*cos(syma) sin(symt)*sin(syma) symr*cos(symt);
          sin(symt) cos(symt)*cos(syma) -cos(symt)*sin(syma) symr*sin(syma);
          0 sin(syma) cos(syma) symd;
          0 0 0 1];
 A1 = subs(A,[symd symt symr syma],[d1 q1 r1 a1])
 A2 = subs(A,[symd symt symr syma],[d2 q2 r2 a2])
 A3 = subs(A,[symd symt symr syma],[d3 q3 r3 a3])
 
 T = A1*A2*A3
  

%  x = cos(q1)*((cos(q2)*l2)+l3*cos(q3+q2));
%  y = sin(q1)*((cos(q2)*l2)+l3*cos(q3+q2));
%  z = l1 + sin(q2)*l2+sin(q2+q3)*l3;
% x = (l2*cos(q2)+l3*sin(q2-q3))*cos(q1);
% y = l2*

jacobian([T(1,4),T(2,4),T(3,4)],[q1,q2,q3])