function [output] = badInterpol(link1Start,link2Start,link1End,link2End)
%interpol outputs a 2x10 matrix of setpoints
%   interpolates between two points and outputs an 2x10 matrix of setpoints
output = [0;0];
link1Increment= abs(link1Start-link1End)/10;
link2Increment= abs(link2Start-link2End)/10;

iterator = 0;

for p = 0:10
    iterator=iterator+1;
    link1toadd = link1Start + (link1Increment*iterator);
    link2toadd = link2Start + (link2Increment*iterator);
    toAdd = [link1toadd; link2toadd];
    if (isequal(output,[0; 0]))
        output = toAdd;
    else
        output = [output toAdd];
    end
end

