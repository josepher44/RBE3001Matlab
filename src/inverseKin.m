function out = inverseKin( x, z, l1, l2 )
%Converts an x and y coordinate into joint angles, 
%   Detailed explanation goes here

%calculate joint angles
q2 = acosd((y^2+x^2-l1^2-l2^2)/(2*l1*l2))+90;
q1 = (-z*l2*sind(q2)+x*(l1+l2*cosd(q2)))/(x*l2*sind(q2)+z*(l1+l2*cos(q2)));

%Append angles into matrix
out = [q1;q2];
end

