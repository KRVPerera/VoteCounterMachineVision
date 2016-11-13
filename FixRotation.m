function [rotationFixedImage] = FixRotation(RGBImage, debug)
    % TODO : check whether whats best to rotate the RGBImage or the
    % filtered one
%     threshold = 0.1;
    if ~exist('debug','var')
        debug = 0;
    end
    %% Thresholding the image
    %RGBImage  = imread('rots.jpg');
    adapt = OptimalThresholdedImage(RGBImage);
    
    %% Edge Detection for hough transform
    cannyseg = edge(adapt,'canny');
    
    %% Perform the Hough transform
    %[H, theta, rho] = hough(cannyseg, 'Theta', -60:0.5:60);
    [H, theta, rho] = hough(cannyseg,'Theta', -45:0.5:45);
    
    %% Locates peaks in the Hough transform matrix
    peak = houghpeaks(H,30,'threshold',ceil(0.5*max(H(:))));
     
    %% Extracts line segments in the image 
    lines = houghlines(cannyseg,theta,rho,peak,'FillGap',250,'MinLength',ceil(numel(RGBImage(:,1,1))/3));
    max_angle =  max(cat(1,lines.theta));
    %% Fix Rotation
    rotationFixedImage = imrotate(RGBImage,max_angle,'bilinear','crop');
    if debug
        figure('Name','Original and Rotation Fixed Image','NumberTitle','off');
        imshowpair(RGBImage,rotationFixedImage,'montage');
    end
end