close all;
clear all;
clc;
% 1 - Bulath Kole, 2 - Bell, 3 - Bicycle, 4 - Elephant, 5 - Hakgediya, 
% 6 - Swan, 7 - House, 8 - Round Flagged Sign
%%
imageName = '3.png';
%% Read Images
object0 = imread(strcat('Signs/',imageName));
Igray = rgb2gray(object0);
object = OptimalThresholdedImage(Igray);
figure,imshow(object);
title('All signs');
%% Sign Region Dividing
Ifinal = bwlabel(object);
stat = regionprops(Ifinal,'Area','MajorAxisLength','BoundingBox','Perimeter','Solidity');
%% Masking
mask = false(size(Igray));
%% Test Regions
figure;imshow(object); hold on;
index = 1;
maMean = mean(cat(1,stat.MajorAxisLength));
maZigma = std(cat(1,stat.MajorAxisLength));
areaMean = mean(cat(stat.Area));
areaZigma = std(cat(stat.Area));
for cnt = 1 : numel(stat)
    bb = stat(cnt).BoundingBox;
    if abs(stat(cnt).Area-areaMean) > 3*areaZigma  || abs(stat(cnt).MajorAxisLength-maMean) > 3*maZigma
      bb2 = round(bb);
      rectangle('position',bb2,'edgecolor','r','linewidth',2);
      
      %mask(bbox2points(bb)) = true;
      
      index = index + 1;
    end
end
%%
visboundaries(mask,'Color','b'); 
%%
bw = activecontour(object, mask, 200, 'Chan-Vese');
% Display the final contour on the original image in red.
visboundaries(bw,'Color','r');

%% Filling - Not recommended as there may be many circles
Icomp = imcomplement(object);
Ifilled = imfill(Icomp,'holes');
%bw = activecontour(Icomp,Ifilled);
figure;imshow(Ifilled);
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
%%
dd = ~Iopenned;
mmnt = moment(Iopenned,3,3);
mmnt
%% Use feature analysis to count skittles objects
idxOfSkittles = find(eccentricities);
statsDefects = stats(idxOfSkittles);

for idx = 1 : length(idxOfSkittles)
   h = rectangle('Position', statsDefects(idx).BoundingBox);
   set(h, 'EdgeColor', [.75 0 0]);
   hold on;
end
hold off;