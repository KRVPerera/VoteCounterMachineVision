function [binaryimage] =  OptimalThresholdedImage(RGBimage)
    if size(RGBimage,3)== 3
        Igray = rgb2gray(RGBimage);
        filterdI = Igray;%medfilt2(Igray);
    else
        filterdI = RGBimage;%medfilt2(RGBimage);
    end
    
    % streching will fail the thresholding
    %imadjust(RGBimage0, stretchlim(RGBimage0));
    %RGBimage(:,:,1));
    level = graythresh(filterdI);
    % Don't use median localization for large images
    T = adaptthresh(filterdI,level,'ForegroundPolarity','bright','Statistic','mean');
    binaryimage = imbinarize(filterdI, T);

    % More advanced based on the RGB planes or better to convert to HSV
    %threshForPlanes = zeros(3,1);
    %for i = 1:3
     %   threshForPlanes(i,:) = graythresh(RGBimage(:,:,i));
    %end
    %threshForPlanes
end