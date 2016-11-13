function [UpperRegion, LowerRegion] = BasicSegmentation(RGBimage, debug)
    if ~exist('debug','var')
        debug = 0;
    end

    Ibw = ~OptimalThresholdedImage(RGBimage);
    Ifill = imfill(Ibw,'holes');
    Iarea = bwareaopen(Ifill,100);
    Ifinal = logical(Iarea);
    %% Getting overall properties to segment main regions
    stat = regionprops(Ifinal,'Area','BoundingBox','Solidity');
    regions = zeros(2,4);
    regs = zeros(2);
    index = 1;
    if debug
        figure;imshow(RGBimage); hold on;
    end
    for cnt = 1 : numel(stat)
        bb = stat(cnt).BoundingBox;
        if stat(cnt).Area > mean(cat(stat.Area)) &&  stat(cnt).Solidity > mean(cat(1,stat.Solidity))
            %PossibleBox(stat(cnt))
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
        UpperRegion = imcrop(RGBimage, regions(1,:));
        LowerRegion = imcrop(RGBimage, regions(2,:));
    else
        UpperRegion = imcrop(RGBimage, regions(2,:));
        LowerRegion = imcrop(RGBimage, regions(1,:));
    end
    if debug
       figure('Name','Original and Rotation Fixed Image','NumberTitle','off');imshowpair(UpperRegion, LowerRegion, 'montage'); 
    end
end