function [time,pos,vel,accel] = trajectory(tStart,tEnd,vStart,vEnd,pStart,pEnd,timeStep)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

tDiff = tEnd-tStart;
n = tDiff/timeStep
tMax = n*timeStep;

for x = 0:n
   time = tStart + n*timeStep;
   %generate some position function
   %take first and second derivatives
   %find setpoints along that trajectory in pos vel and accel
end

end

