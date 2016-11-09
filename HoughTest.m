%% Clear
close all;
%clear all;
%clc;
%% load image
I = imread('rots.jpg');
HoughTransformVisualization(I);
%% Global Threshold for the image
%filterdI = medfilt2(I(:,:,1));
%level = graythresh(filterdI);
%T = adaptthresh(filterdI(:,:,1),level);
adapt = OptimalThresholdedImage(I);%imbinarize(filterdI(:,:,1), T);
%%
figure(), imshow(adapt);
%% Edge detection
cannyseg = edge(adapt,'sobel');
%figure(), imshow(cannyseg);
%% Perform the Hough transform
[H, theta, rho] = hough(cannyseg,'Theta', -60:0.5:60);
% Find the peak pt in the Hough transform
peak = houghpeaks(H,5);
% Find the angle of the bars
barAngle = theta(peak(1,2))
%% Peak Test
imshow(H,[],'XData',theta,'YData',rho,'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
plot(theta(peak(:,2)),rho(peak(:,1)),'s','color','white');
%% Rotating the image
% if barAngle >= -90 && barAngle <= 90
%    barAngle =  
% end
J = imrotate(I, barAngle, 'bilinear', 'crop');
figure()
imshowpair(J, I, 'montage');
%imshow(J);
%imsave
