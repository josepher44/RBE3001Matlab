function [time,pos,vel,accel] = trajectory(tStart,tEnd,vStart,vEnd,pStart,pEnd,timeStep)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

syms t;

tDiff = tEnd-tStart;
n = tDiff/timeStep
tMax = n*timeStep;

%Generate matrix to solve for polynomial constants
A = [1 tStart tStart^2 tStart^3;
     0 1      2*tStart 3*tStart^2;
     1 tEnd   tEnd^2   tEnd^3;
     0 1      2*tEnd   3*tStart^2];
 
%Create column vector of position and velocity
q = [pStart;vStart;pEnd;vEnd];

%Create column vector of coefficients
coeffs = inverse(A)*q;

%generate polynomial
poly = coeffs(1)*t^3 + coeffs(2)*t^2 + coeffs(3)*t + coeffs(4);

%Now, iterate across the polynomial by plugging in values of t incremented
%by timeStep

for x = 0:n
   time = tStart + n*timeStep;
   %generate some position function
   %take first and second derivatives
   %find setpoints along that trajectory in pos vel and accel
end

end

