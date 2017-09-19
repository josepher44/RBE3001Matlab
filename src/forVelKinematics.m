function [ M ] = forVelKinematics( vx,vy,vz,q1,q2,q3 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
syms l1 l2 l3



%M = [nx ox ax px; ny oy ay py1; nz oz az pz; 0 0 0 1];
J = [-sind(q1) -l2*sind(q2)-l3*sind(q2) -l3*sind(q3); ...
    cosd(q1) -l2*sind(q2)-l3*sind(q2) -l3*sind(q3); ...
    0 l2*cosd(q2)+l3*cosd(q2) l3*cosd(q3)];

V = [vx;vy;vz];

M = J*V;


end

