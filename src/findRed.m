function [coordinates radius] = findRed(img) 
    diff = imsubtract(img(:,:,1), rgb2gray(img)); %remove gray part of image
    diff = medfilt2(diff, [3 3]); %filter out any strange values
%     imshow(img);
    diff = imbinarize(diff,0.18); %turn this into a binary file
%     diff = bwareaopen(diff,300);
    bw = bwlabel(diff,8);
%     se = strel('disk',5);
%     dilatedBW = imdilate(bw,se);
    [c,r] = imfindcircles(bw,[20 40],'ObjectPolarity','bright','Sensitivity',0.95); 
    biggestR = 0;
    biggestRC = [0 0];
    for thing = 1:length(r)
      if r(thing)>biggestR
          biggestR = r(thing);
          biggestRC = c(thing,:);
      end
    end
    radius = biggestR;
    coordinates = biggestRC;
end

