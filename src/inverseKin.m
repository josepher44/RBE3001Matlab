function out = inverseKin( x, y, z)
%Converts an x, y, and z coordinate into joint angles, 

l1 = 90;
l2 = 166;
l3 = 200;

%Offsets Z by a constant value to account for L1 length (only time this
%impacts anything)
z = z+l1;

%calculate joint angle 1
q1 = atand(y/x);

%Calculates r, since this is used repeatedly
r = x*cosd(q1);

%Calculates remaining angles
q3 = acosd((r^2+z^2-(l2^2+l3^2))/(2*l2*l3))+90;
q2 = atand(z/r) + acosd((r^2+z^2+l2+l3)/(2*l2*sqrt(r^2+z^2)));

%Append angles into matrix
out = [q1*11.44;q2*11.44;q3*11.44];
end

