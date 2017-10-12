
function [q1,q2,q3] = invKinematics (x,y,z)
    l1 = 20.0;
    l2 = 16.6;
    l3 = 20.0;
    
    %increment so that the center is same as camera origin
    x=x+16.6;
    
    r = sqrt(x^2 + y^2);
    
    zOffset = l1-z;
    
    distance = sqrt(r^2 + zOffset^2);
    
    hypotenuse = sqrt(r^2 + l1^2);
    
    % interior angle of a top down view
    q1 = atan2d(y,x);
    
    % interior angle of the sum of three triangles
    q2 = acosd((distance^2 + l2^2 -l3^2) / (2 * distance * l2))+acosd((distance^2 + hypotenuse^2 - z^2) / (2 * distance * hypotenuse)) + acosd ((l1^2 + hypotenuse^2 - r^2) / (2 * l1 * hypotenuse));
    
    % offset to make home position 0,0,0
    q2=q2-90;
    
    
    q3 = acosd ((l2^2 + l3^2 - distance^2) / (2* l2 * l3));
    % offset to make home position 0,0,0
    q3 = q3-90;
end
