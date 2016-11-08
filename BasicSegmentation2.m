function [region1, region2] = BasicSegmentation2(RGBimage, debug)
    if ~exist('debug','var')
        debug = 0;
    end

    Ibw = ~OptimalThresholdedImage(RGBimage);
    Ifill = imfill(Ibw,'holes');
    Iarea = bwareaopen(Ifill,100);
    Ifinal = logical(Iarea);
    %% Getting overall properties to segment main regions
    stat = regionprops(Ifinal,'Area','MajorAxisLength','BoundingBox','Perimeter','Solidity');
    regions = zeros(2,4);
    regs = zeros(2);
    index = 1;
    if debug
        imshow(RGBimage); hold on;
    end
    for cnt = 1 : numel(stat)
        bb = stat(cnt).BoundingBox;
        if stat(cnt).Area > mean(cat(stat.Area)) &&  stat(cnt).Solidity > mean(cat(1,stat.Solidity))
            regions(index,:)= bb;
            regs(index) = cnt;
            index = index + 1;
             if debug
               rectangle('position',bb,'edgecolor','r','linewidth',2);
             end
        end
    end
    %% Cropping Regions
    if stat(regs(1)).Area > stat(regs(2)).Area
        region1 = imcrop(Ibw, regions(1,:));
        region2 = imcrop(Ibw, regions(2,:));
    else
        region1 = imcrop(Ibw, regions(2,:));
        region2 = imcrop(Ibw, regions(1,:));
    end
    %stat1 = regionprops(region1,'Area','MajorAxisLength','BoundingBox','Perimeter','Solidity');
    if debug
       figure;imshowpair(region1, region2, 'montage'); 
    end
end