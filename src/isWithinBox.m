function [boolean] = isWithinBox(x,y)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    % TL = 600, 345
    % TR = 1306, 404
    % BL = 425, 1065
    % BR = 1462 1077

boolean = (y<540)&&(y>115)&&(x<515)&&(x>160);

end

