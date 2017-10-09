function [coordinates] = findColorFast(img) 
    bw = testcreateMask(img);
SE3 = strel('disk', 15) 
    
    bw = imerode(bw,SE3);
    %bw = imdilate(bw,SE3);
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

