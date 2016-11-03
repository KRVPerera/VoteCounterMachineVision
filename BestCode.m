%% Clear
close all;
clear all;
clc;
%% load images
I = imread('001_backup.jpg');

%% Optimal Threshold for the image
adapt = OptimalThresholdedImage(I);
%ilngtmilT = OptimalThresholdedImage(ilngtmil);
%adapt_small = imresize(adapt, 0.5);
%%
figure;imshow(adapt);
%% Hough Visualization
HoughTransformVisualization(I);
%% Fix Rotation
rotationFixed = FixRotation(I);
%% Display the results
imshowpair(I, rotationFixed, 'montage')
%% Remove small objects
BW2 = bwareaopen(adapt, 50);
imshowpair(BW2, adapt, 'montage');
%imsave
%% Extended_maxima
BW3 = imextendedmax(I,80);
imshowpair(BW3, I, 'montage');
%imsave
%% Image H max
I1 = imhmax(I,100);
I2 = OptimalThresholdedImage(I1);
figure();imshowpair(I2, I, 'montage');
%imsave
%% Top Hat
se = strel('s',12);
tophatFiltered = imtophat(I(:,:,2),se);
contrastAdjusted = imadjust(gather(tophatFiltered));
figure, imshow(contrastAdjusted);
imsave

