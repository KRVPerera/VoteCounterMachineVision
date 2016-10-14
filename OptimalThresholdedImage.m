function [binaryimage] =  OptimalThresholdedImage(RGBimage)
    filterdI = medfilt2(RGBimage(:,:,2));
    level = graythresh(filterdI);
    % Don't use median localization for large images
    T = adaptthresh(filterdI,level,'ForegroundPolarity','bright','Statistic','gaussian');
    binaryimage = imbinarize(filterdI, T);

    %% More advanced based on the RGB planes or better to convert to HSV
    %threshForPlanes = zeros(3,1);
    %for i = 1:3
     %   threshForPlanes(i,:) = graythresh(RGBimage(:,:,i));
    %end
    %threshForPlanes
end