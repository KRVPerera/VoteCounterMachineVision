close all;
clear all;
clc;
% 1 - Bulath Kole, 2 - Bell, 3 - Bicycle, 4 - Elephant, 5 - Hakgediya, 
% 6 - Swan, 7 - House, 8 - Round Flagged Sign
%% Read Images
object0 = imread('Signs/6.png');
Igray = rgb2gray(object0);
%imtool(Igray);
%se = strel('sphere', 1);
%bw = activecontour(Icomp, se);
%cannyseg = edge(Igray,'canny');
%imshow(bw);
%% Show the sign
object = OptimalThresholdedImage(Igray);
figure,imshow(object);
%% Filling - Not recommended as there may be many circles
Icomp = imcomplement(object);
Ifilled = imfill(Icomp,'holes');
%bw = activecontour(Icomp,Ifilled);
%imshow(bw);
%% More filliing
se = strel('sphere', 1);
Iopenned0 = imopen(Ifilled, se);
imshow(Iopenned0);
%%
Iopenned = bwareaopen(Iopenned0, 310);
figure,imshow(Iopenned);

%% Extract features
Iregion = regionprops(Iopenned, 'centroid');
[labeled, numObjects] = bwlabel(Iopenned,4);
stats = regionprops(labeled, 'Eccentricity', 'Area', 'BoundingBox');
areas = [stats.Area];
eccentricities = [stats.Eccentricity];

%% Use feature analysis to count skittles objects
idxOfSkittles = find(eccentricities);
statsDefects = stats(idxOfSkittles);

for idx = 1 : length(idxOfSkittles)
   h = rectangle('Position', statsDefects(idx).BoundingBox);
   set(h, 'EdgeColor', [.75 0 0]);
   hold on;
end
hold off;