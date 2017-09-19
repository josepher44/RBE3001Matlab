function out = velocityFromVector( in )
%Takes the vector to move along as an input, and provides an x, y, and z
%target velocity as an output, scaled according to magnitude

Kp = 0.01;

%magnitude = sqrt(in(1:1)^2+in(1:2)^2+in(i:3)^2);

out = [in(1:1)*Kp;
       in(1:2)*Kp;
       in(1:3)*Kp;]


end

