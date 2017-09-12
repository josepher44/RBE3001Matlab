function output = xy_interpolation( x1 y1 x2 y2 n )
%Generates an 2 by x matrix of x and y coordinates interpolating in a
%straight line between two points, with a total number of values specified
%by argument n

%increment n by 1, so that an argument of zero corresponds to using the
%inputted end points only, with zero interpolated points. 
n = n+1

%initialize the output array
outputx = zeros(1, n+1);
outputy = zeros(1, n+1);

for i=0:n

    %Calculates next x and y coordinate, by adding % to end point to start
    %point
    xnew = x1+(i/n)*x2;
    ynew = y1+(i/n)*y2;

    %Adds these values to row matrices
    outputx(i+1) = xnew;
    outputy(i+1) = ynew;
   
end

%Appends the two row matrices into a 2xn matrix
output = [outputx;outputy];


end

