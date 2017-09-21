function  M  = forVelKinematics( vx,vy,vz,q1,q2,q3 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
syms l1 l2 l3



%M = [nx ox ax px; ny oy ay py1; nz oz az pz; 0 0 0 1];
J = [ - 166*cos(q2)*sin(q1) - 200*cos(q2)*cos(q3)*sin(q1), - 166*cos(q1)*sin(q2) - 200*cos(q1)*cos(q3)*sin(q2), -200*cos(q1)*cos(q2)*sin(q3)
       166*cos(q1)*cos(q2) + 200*cos(q1)*cos(q2)*cos(q3), - 166*sin(q1)*sin(q2) - 200*cos(q3)*sin(q1)*sin(q2), -200*cos(q2)*sin(q1)*sin(q3)
                                                       0,                                -200*cos(q2)*cos(q3),          200*sin(q2)*sin(q3)];

V = [vx;vy;vz];

M = J*V;


end

