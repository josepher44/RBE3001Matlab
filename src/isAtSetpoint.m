function isatsetpoints = isAtSetpoint(setpoints, encoders)
   accuracy = 0.04;
   
   range1 = 2310;
   range2 = 1485;
   range3 = 2757;
   cutoff = [accuracy*range1*0.4 accuracy*range2 accuracy*range3];

   isatsetpoints = 0;
   for i=1:3
       if abs(setpoints(i)-encoders(i))<cutoff(i)
           isatsetpoints= isatsetpoints+ 1;
           %disp("At setpoint!");
       else
           isatsetpoints= 0;
       end
       % isatsetpoints = mod(isatsetpoints,3);
   end
end
