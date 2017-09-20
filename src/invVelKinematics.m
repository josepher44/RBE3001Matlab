function   M = invVelKinematics(vx,vy,vz,q1,q2,q3 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

l1 = 90;
l2 = 166;
l3 = 200;
q3 = q3 - 90;
q1=deg2rad(q1);
q2=deg2rad(q2);
q3=deg2rad(q3);



J = [  cos(q1)*(l3*cos(q2 + q3) + l2*cos(q2)), -sin(q1)*(l3*sin(q2 + q3) + l2*sin(q2)), -l3*sin(q2 + q3)*sin(q1);
      -sin(q1)*(l3*cos(q2 + q3) + l2*cos(q2)), -cos(q1)*(l3*sin(q2 + q3) + l2*sin(q2)), -l3*sin(q2 + q3)*cos(q1);
                                            0,            l3*cos(q2 + q3) + l2*cos(q2),          l3*cos(q2 + q3)];

% J = [   cos(q1)*(l3*cos(q1 + q2) + l2*cos(q2)) - l3*sin(q1 + q2)*sin(q1), -sin(q1)*(l3*sin(q1 + q2) + l2*sin(q2)),               0;
%       - sin(q1)*(l3*cos(q1 + q2) + l2*cos(q2)) - l3*sin(q1 + q2)*cos(q1), -cos(q1)*(l3*sin(q1 + q2) + l2*sin(q2)),               0;
%                                                                        0,            l3*cos(q2 + q3) + l2*cos(q2), l3*cos(q2 + q3)];



% J = [cos(q1)*(l3*cos(q1+q2)+l2*cos(q2)*sin(q1))-sin(q1)*(l3*sin(q1+q2)-l2*cos(q1)*cos(q2)) -sin(q1)*(l3*sin(q1+q2)+l2*sin(q1)*sin(q2)) 0;
%     -sin(q1)*(l3*cos(q1+q2)+l2*cos(q1)*cos(q2))-cos(q1)*(l3*sin(q1+q2)+l2*cos(q2)*sin(q1)) -cos(q1)*(l3*sin(q1+q2)+l2*cos(q1)*sin(q2)) 0;
%      0 l3*cos(q2+q3)+l2*cos(q2) l3*cos(q2+q3)];
C = inv(J);

Q = [vx;vy;vz];

M = C*Q;
M = rad2deg(M);
end

