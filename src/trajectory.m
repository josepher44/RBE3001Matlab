function out = trajectory(tStart,tEnd,vStart,vEnd,pStart,pEnd,timeStep)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

syms t time;

tDiff = tEnd-tStart;
n = tDiff/timeStep;
tMax = n*timeStep;

%Generate matrix to solve for polynomial constants
A = [1 tStart tStart^2 tStart^3;
     0 1      2*tStart 3*tStart^2;
     1 tEnd   tEnd^2   tEnd^3;
     0 1      2*tEnd   3*tEnd^2];
 
%Create column vector of position and velocity
q = [pStart;vStart;pEnd;vEnd];

%Create column vector of coefficients
coeffs = inv(A)*q;

%generate polynomials
position = symfun(coeffs(4)*t^3 + coeffs(3)*t^2 + coeffs(2)*t + coeffs(1), t);
velocity = symfun(3*coeffs(4)*t^2 + 2*coeffs(3)*t + coeffs(2), t);
acceleration = symfun(6*coeffs(4)*t + 2*coeffs(3), t);

%Now, iterate across the polynomial by plugging in values of t incremented
%by timeStep

out = [];
for x = 0:n
   time = tStart + x*timeStep;
   pnew = position(time);
   vnew = velocity(time);
   anew = acceleration(time);
   out = [out;time pnew vnew anew];
   out = double(out);
   %generate some position function
   %take first and second derivatives
   %find setpoints along that trajectory in pos vel and accel
end

end

