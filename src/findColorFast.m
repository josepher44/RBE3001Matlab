function [color, x,y] = findColorFast(img)
%blackMask = (img(:,:,1)+img(:,:,2)+img(:,:,3)>50);
%color = 0;
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
color=0;
figure(2)
stats = regionprops(bw,'BoundingBox','Centroid');
imshow(img);
hold on;
c=[,];
for object = 1:length(stats)
    if isWithinBox(stats(object).Centroid(1),stats(object).Centroid(2))
        bb = stats(object).BoundingBox;
        bc = stats(object).Centroid;
        m=round(bc(1))
        n=round(bc(2))
        color = colorDetermination(m,n, img);
        plot(m,n, '-m+');
        if color==1
            rectangle('Position',bb,'EdgeColor','y','LineWidth',1);
        else
            if color==2
                rectangle('Position',bb,'EdgeColor','g','LineWidth',1);
            else
                if color==3
                    rectangle('Position',bb,'EdgeColor','c','LineWidth',1);
                else
                    color = 4;
                end
            end
        end
        c = [c;stats(object).Centroid(1),stats(object).Centroid(2)];
    else
        color=0;
    end
    hold off;
end
if(~((color==1)||(color==2)||(color==3)||(color==4)))
    color = 5;
end

if(length(c)>1)
    [x,y] = mn2xy(c(1),c(2));
else
    x=-10000;
    y=-10000;
end




end

