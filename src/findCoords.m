function [x y] = findCoords(cam)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    img = snapshot(cam);
    hold on;
    imshow(img);
    [coords,radius] = findRed(img);
    viscircles(coords,radius);
    hold off;
[x,y] = mn2xy(coords(1),coords(2));

end


