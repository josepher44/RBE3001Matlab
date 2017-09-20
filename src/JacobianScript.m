syms q1 q2 q3 l1 l2 l3;

 x = sin(q1)*((cos(q2)*l2)+l3*cos(q3+q2));
 y = cos(q1)*((cos(q2)*l2)+l3*cos(q3+q2));
 z = l1 + sin(q2)*l2+sin(q2+q3)*l3;
% x = (l2*cos(q2)+l3*sin(q2-q3))*cos(q1);
% y = l2*

jacobian([x,y,z],[q1,q2,q3])