function [result] = findRedCircle(cam, size)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    tic
    img = snapshot(cam);
    if(not(size==1))
        img = imresize(img,size);
    end
    masked = createMask(img);
    %%masked = bwareafilt(masked,1); remove largest
    maskedFixed = bwareaopen(masked,50);
    %      maskedGPU = gpuArray(masked);
    stats = regionprops('table',maskedFixed,'Centroid',...
        'MajorAxisLength','MinorAxisLength');
    centers = stats.Centroid;
%     diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
    diameters = stats.MajorAxisLength;
    radii = diameters/2;
    hold on
     imshow(img)
     viscircles(centers,radii);
    hold off
    result = toc;
end

