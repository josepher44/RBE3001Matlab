function [bool] = goToEnc( e1,e2,e3,pp )

values = zeros(15, 1, 'single');

limits = [ 0, 0; 0, 0; 0, 0;];
if limits(1,1)<e1<limits(1,2) && limits(2,1)<e2<limits(2,2) && ...
        limits(3,1)<e3<limits(3,2)
    disp([e1,e2,e3])
    error('Position excedes range of motion')
    
end




values(1) = round(e1);
values(4) = round(e2);
values(7) = round(e3);
values = single(values);

returnValues = pp.command(38, values);

encoders = [returnValues(1),returnValues(2),returnValues(3)]
setpoints = [e1 e2 e3];
if(isAtSetpoint(setpoints,encoders)==3)
    bool = true;
else
    bool = false;
end


end

