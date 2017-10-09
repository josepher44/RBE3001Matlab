function out = inverseKin( x, y, z)
%Converts an x, y, and z coordinate into joint angles, 
x=-x;
x=x+166;

l1 = 200;
l2 = 166;
l3 = 200;

%Offsets Z by a constant value to account for L1 length (only time this
%impacts anything)
%z = -(z+l1);

%calculate joint angle 1
q1 = atand(y/x);

%Calculates r, since this is used repeatedly
r = sqrt((x^2)+(y^2));

%Calculates remaining angles
q3 = acosd((r^2+z^2 -(l2^2+l3^2))/(2*l2*l3))-90;
q2a = acosd((r^2+z^2+(l2^2)-(l3^2))/(2*l2*sqrt(r^2+z^2))) + atan2d(z,r);
q2b = acosd((r^2+z^2+(l2^2)-(l3^2))/(2*l2*sqrt(r^2+z^2))) + atan2d(-z,r);
q2c = acosd((r^2+z^2+(l2^2)-(l3^2))/(2*l2*sqrt(r^2+z^2))) + atan2d(z,-r);
q2d = acosd((r^2+z^2+(l2^2)-(l3^2))/(2*l2*sqrt(r^2+z^2))) + atan2d(-z,-r);

q2e = acosd((r^2+z^2+(l2^2)-(l3^2))/(2*l2*sqrt(r^2+z^2))) - atan2d(z,r);
q2f = acosd((r^2+z^2+(l2^2)-(l3^2))/(2*l2*sqrt(r^2+z^2))) - atan2d(-z,r);
q2g = acosd((r^2+z^2+(l2^2)-(l3^2))/(2*l2*sqrt(r^2+z^2))) - atan2d(z,-r);
q2h = acosd((r^2+z^2+(l2^2)-(l3^2))/(2*l2*sqrt(r^2+z^2))) - atan2d(-z,-r);

out = -[q2a,q2b,q2c,q2d,q2e,q2f,q2g,q2h];

% q2 = acosd(((r^2)-1*l3^2+l2^2)/(2*l2*r))-atand(z/r);
%Append angles into matrix
%out = [q1;-q2;q3];
%out = out*11.44;
end

