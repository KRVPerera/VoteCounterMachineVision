function [rotationFixedImage] = FixRotation(RGBImage)
    %% Thresholding the image
    adapt = OptimalThresholdedImage(RGBImage);
    %% Edge Detection for hough transform
    cannyseg = edge(adapt,'canny');
    %% Perform the Hough transform
    [H, theta, rho] = hough(cannyseg);
    % Find the peak pt in the Hough transform
    % Need to select the best peak ?
    peak = houghpeaks(H,2);
    % Find the angle of the bars
    barAngle = theta(peak(3));
    %% Fix Rotation
    rotationFixedImage = imrotate(RGBImage, barAngle, 'bilinear', 'crop');
end