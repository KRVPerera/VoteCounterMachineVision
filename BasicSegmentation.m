function [region1, region2] = BasicSegmentation(RGBimage, debug)
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
    index = 1;
    if debug
        imshow(RGBimage); hold on;
    end
    for cnt = 1 : numel(stat)
        bb = stat(cnt).BoundingBox;
        if stat(cnt).Area > mean(cat(stat.Area)) &&  stat(cnt).Solidity > mean(cat(1,stat.Solidity))
            %PossibleBox(stat(cnt))
            regions(index,:)= bb;
            index = index + 1;
             if debug
               rectangle('position',bb,'edgecolor','r','linewidth',2);
             end
        end
    end
    %% Cropping Regions
    region1 = imcrop(RGBimage, regions(1,:));
    region2 = imcrop(RGBimage, regions(2,:));
    if debug
       figure;imshowpair(region1, region2, 'montage'); 
    end
end