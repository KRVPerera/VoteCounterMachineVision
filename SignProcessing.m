close all;
clear all;
clc;
%% Read Images
object0 = imread('IlangeiTamilArasu.png');
object = OptimalThresholdedImage(object0);
% Show the sign
figure,imshow(object);
%% Filling - Not recommended as there may be many circles
Icomp = imcomplement(object);
Ifilled = imfill(Icomp, 'holes');
figure, imshow(Ifilled);
%% More filliing
se = strel('sphere', 2);
Iopenned0 = imopen(Ifilled, se);
figure, imshow(Iopenned0);
%%
Iopenned = bwareaopen(Iopenned0, 50);
imshow(Iopenned);
%% Extract features
Iregion = regionprops(Iopenned, 'centroid');
[labeled, numObjects] = bwlabel(Iopenned,4);
stats = regionprops(labeled, 'Eccentricity', 'Area', 'BoundingBox');
areas = [stats.Area];
eccentricities = [stats.Eccentricity];

%% Use feature analysis to count skittles objects
idxOfSkittles = find(eccentricities);
statsDefects = stats(idxOfSkittles);

figure, imshow(object0);hold on;
for idx = 1 : length(idxOfSkittles)
   h = rectangle('Position', statsDefects(idx).BoundingBox);
   set(h, 'EdgeColor', [.75 0 0]);
   hold on;
end
hold off;
