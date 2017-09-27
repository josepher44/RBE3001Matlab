function [bool,returnValues] = goToXYZ( x,y,z,pp )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

P = inverseKin(x,y,z);

values = zeros(15, 1, 'single');

% limits = [ 0, 2000; 0, 2000; 0, 200;];
% if limits(1,1)<P(1)<limits(1,2) && limits(2,1)<P(2)<limits(2,2) && ...
%         limits(3,1)<P(3)<limits(3,2)
%     disp(P)
%     error('Position excedes range of motion')
%     
% end




values(1) = round(P(1));
values(4) = round(P(2));
values(7) = round(P(3));
values = single(values);

returnValues = pp.command(38, values);

encoders = [returnValues(1),returnValues(4),returnValues(7)]
setpoints = transpose(P);
if(isAtSetpoint(setpoints,encoders)==3)
   bool = true;
else
    bool = false;
end


end

