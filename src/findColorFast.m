function [x,y] = findColorFast(img) 
    %blackMask = (img(:,:,1)+img(:,:,2)+img(:,:,3)>50);
    colorMask = createMaskMk3(img);
    bw = colorMask;
%     figure(1);
%     imshow(colorMask);
%     figure(2);
%     imshow(blackMask);
%     figure(3);
%     imshow(blackMask&colorMask)
    SE2 = strel('disk', 1);
    SE3 = strel('disk', 10);
    bw = imdilate(bw,SE2);
    bw = imerode(bw,SE3);
    %
%     se = strel('disk',5);
%     dilatedBW = imdilate(bw,se);
    figure(2)
    stats = regionprops(bw,'BoundingBox','Centroid');
    %imshow(img);
    imshow(img);
    hold on;
    c=[,];
    for object = 1:length(stats)
        if isWithinBox(stats(object).Centroid(1),stats(object).Centroid(2))
            bb = stats(object).BoundingBox;
            bc = stats(object).Centroid;
            rectangle('Position',bb,'EdgeColor','r','LineWidth',2);
            plot(bc(1),bc(2), '-m+');
            c = [c;stats(object).Centroid(1),stats(object).Centroid(2)];
        else
%             bb = stats(object).BoundingBox;
%             bc = stats(object).Centroid;
%             rectangle('Position',bb,'EdgeColor','b','LineWidth',2)
%             plot(bc(1),bc(2), '-m+')
        end

    end
    %within
    % TL = 600, 345
    % TR = 1306, 404
    % BL = 425, 1065
    % BR = 1462 1077
    if(length(c)>0)
        [x,y] = mn2xy(c(1),c(2));
    else
        x=-10000;
        y=-10000;
    end
    hold off;
end

