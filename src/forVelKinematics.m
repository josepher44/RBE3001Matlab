function  M  = forVelKinematics( vx,vy,vz,q1,q2,q3 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
syms l1 l2 l3



%M = [nx ox ax px; ny oy ay py1; nz oz az pz; 0 0 0 1];
J = [cos(q1)*(l3*cos(q1+q2)+l2*cos(q2)*sin(q1))-sin(q1)*(l3*sin(q1+q2)-l2*cos(q1)*cos(q2)) -sin(q1)*(l3*sin(q1+q2)+l2*sin(q1)*sin(q2)) 0;
    -sin(q1)*(l3*cos(q1+q2)+l2*cos(q1)*cos(q2))-cos(q1)*(l3*sin(q1+q2)+l2*cos(q2)*sin(q1)) -cos(q1)*(l3*sin(q1+q2)+l2*cos(q1)*sin(q2)) 0;
     0 l3*cos(q2+q3)+l2*cos(q2) l3*cos(q2+q3)];

V = [vx;vy;vz];

M = J*V;


end

