function [boolean] = isWithinBox(x,y)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    % TL = 600, 345
    % TR = 1306, 404
    % BL = 425, 1065
    % BR = 1462 1077

boolean = (x<1462)&&(x>425)&&(y<1077)&&(y>345);

end

