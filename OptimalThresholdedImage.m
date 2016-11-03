function [binaryimage] =  OptimalThresholdedImage(RGBimage0)
    RGBimage = RGBimage0;
    %Igray = rgb2gray(I);
    % streching will fail the thresholding
    %imadjust(RGBimage0, stretchlim(RGBimage0));
    filterdI = medfilt2(RGBimage(:,:,1));
    level = graythresh(filterdI);
    % Don't use median localization for large images
    T = adaptthresh(filterdI,level,'ForegroundPolarity','bright','Statistic','mean');
    binaryimage = imbinarize(filterdI, T);

    %% More advanced based on the RGB planes or better to convert to HSV
    %threshForPlanes = zeros(3,1);
    %for i = 1:3
     %   threshForPlanes(i,:) = graythresh(RGBimage(:,:,i));
    %end
    %threshForPlanes
end