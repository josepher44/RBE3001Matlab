function [coordinates] = findRedFast(img) 
    diff = imsubtract(img(:,:,1), rgb2gray(img)); %remove blue part of image
    diff = medfilt2(diff, [3 3]); %filter out any strange values
%     imshow(img);
    diff = imbinarize(diff,0.1); %turn this into a binary file
%     diff = bwareaopen(diff,300);
    bw = bwlabel(diff,8);
%     se = strel('disk',5);
%     dilatedBW = imdilate(bw,se);
    figure(2)
    stats = regionprops(bw,'BoundingBox','Centroid');
     imshow(img);
    
    hold on;
    c=[,];
    for object = 1:length(stats)
        if isWithinBox(stats(object).Centroid(1),stats(object).Centroid(2))
            bb = stats(object).BoundingBox;
            bc = stats(object).Centroid;
            rectangle('Position',bb,'EdgeColor','r','LineWidth',2)
            plot(bc(1),bc(2), '-m+')
            c = [c;stats(object).Centroid(1),stats(object).Centroid(2)]
        else
            bb = stats(object).BoundingBox;
            bc = stats(object).Centroid;
            rectangle('Position',bb,'EdgeColor','b','LineWidth',2)
             plot(bc(1),bc(2), '-m+')
        end

    end
    %within
    % TL = 600, 345
    % TR = 1306, 404
    % BL = 425, 1065
    % BR = 1462 1077
    coordinates = c;
    hold off;
end

