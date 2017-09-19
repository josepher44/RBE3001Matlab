function M = forPosKinematicsTransformation( q1, q2, q3 )
%Takes 3 join values and returns 4x4 homogenous transformation
%matrix
%   Detailed explanation goes here

syms l1 l2 l3

%M = [nx ox ax px; ny oy ay py1; nz oz az pz; 0 0 0 1];
M = [cosd(q1)*cosd(q1+q2) -cosd(q1)*sind(q1+q2) sind(q1) (l1 + l2*cosd(q2))*cosd(q1); ...
    sind(q1)*cosd(q1+q2) -sind(q1)*sind(q1+q2) -cosd(q1) (l1 + l2*cosd(q2))*sind(q1); ...
    sind(q2+q3) cosd(q2+q3) 0 l2*sind(q2); ...
    0 0 0 1];



% nx = cosd(q1)*cosd(q1+q2);
% ox = -cosd(q1)*sind(q1+q2);
% ax = sind(q1);
% px = (l1 + l2*cosd(q2))*cosd(q1);
% 
% ny = sind(q1)*cosd(q1+q2);
% oy = -sind(q1)*sind(q1+q2);
% ay = -cosd(q1);
% py1 = (l1 + l2*cosd(q2))*sind(q1);
% 
% nz = sind(q2+q3);
% oz = cosd(q2+q3);
% az = 0;
% pz = l2*sind(q2);

end

