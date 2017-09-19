function out = threeDVector( a, b )
%Function which returns a x, y, and z magnitude given two vectors

out = [b(1:1)-a(1:1);
       b(1:2)-a(1:2);
       b(1:3)-a(1:3)];


end

