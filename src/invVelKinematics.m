function   M = invVelKinematics(vx,vy,vz,q1,q2,q3 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

l1 = 90;
l2 = 166;
l3 = 200;
% q3 = q3 - 90;
q1=deg2rad(q1);
q2=deg2rad(q2);
q3=deg2rad(q3);


J = [ - 166*cos(q2)*sin(q1) - 200*cos(q2)*cos(q3)*sin(q1), - 166*cos(q1)*sin(q2) - 200*cos(q1)*cos(q3)*sin(q2), -200*cos(q1)*cos(q2)*sin(q3)
       166*cos(q1)*cos(q2) + 200*cos(q1)*cos(q2)*cos(q3), - 166*sin(q1)*sin(q2) - 200*cos(q3)*sin(q1)*sin(q2), -200*cos(q2)*sin(q1)*sin(q3)
                                                       0,                                -200*cos(q2)*cos(q3),          200*sin(q2)*sin(q3)];
C = pinv(J);

Q = [vx;vy;vz];

M = C*Q;
M = rad2deg(M);
end

