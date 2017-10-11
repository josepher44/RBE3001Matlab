function [bool,returnValues] = goToXYZ( x,y,z,pp )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[q0,q1,q2] = invKinematics (x,y,z);
P = [q0,q1,q2]*11.44;

values = zeros(15, 1, 'single');


% 
if(isreal(q0) && isreal(q1) && isreal(q2))
    values(1) = round(P(1));
    values(4) = round(P(2));
    values(7) = round(P(3));
    values = single(values);
    returnValues = pp.command(38, values);
    encoders = [returnValues(1),returnValues(4),returnValues(7)];
end


setpoints = transpose(P);
if(isAtSetpoint(setpoints,encoders)==3)
   bool = true;
else
    bool = false;
end


end

