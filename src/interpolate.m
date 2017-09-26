function [setpoints] = interpolate(start,finish,points)

%I don't know why this is necessary
start = single(start);
finish = single(finish);
points = single(points);

%fencepost correction
points = points+1;

%calculate iteration value
difference = finish-start;
rate = difference/points;


setpoints=[];
for x = 0:points
    setpoints = [setpoints; start+rate*x]
end


end

