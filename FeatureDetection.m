close all;
clear all;
clc;
%% Read Images
scene = imread('001_backup.jpg');
%figure;imshow(scene);title('Scene');
object0 = imread('IlangeiTamilArasu.png');
object = OptimalThresholdedImage(object0);
%figure;imshow(object);title('Object');

%%  Detect Features
I = rgb2gray(scene);
O = object;
sceneFeatures = detectSURFFeatures(I);
objectFeatures = detectSURFFeatures(O);

%%  Extract Features
[scenefeats,scenepts] = extractFeatures(I, sceneFeatures);
[objectfeats,objectpts] = extractFeatures(O, objectFeatures);
%% Display Features
figure;imshow(O); hold on;plot(objectpts, 'showOrientation', true');
title('Detected Features');

%% Detect Corners
corners = detectMinEigenFeatures(I);
imshow(I); hold on;
plot(corners.selectStrongest(100));

%% Match Features
index_pairs = matchFeatures(objectfeats, scenefeats, 'Prenormalized', true);
%%
matched_objectpts = objectpts(index_pairs(:, 1));
matched_scenepts = scenepts(index_pairs(:, 2));
%%
figure; showMatchedFeatures(I, O, matched_scenepts, matched_objectpts, 'montage');
title('Initial Matches');

%%
figure
showMatchedFeatures(O,I,matched_objectpts,matched_scenepts)
title('Candidate matched points (including outliers)')

%% Remvoe outliers while estimating the geometric transform using the RANSAC
[tform, lienar_pts_scene, linear_pts_object] = estimateGeometricTransform(matched_scenepts, ...
            matched_objectpts, 'affine');
%% Show matched Fetures
figure; showMatchedFeatures(I, O, lienar_pts_scene, linear_pts_object, 'montage');
title('Filtered Matches');

%% boxPolygon
boxPolygon = [size(I,2), size(I,1); 1,size(I, 1); 1, 1];
% Use estimated transform to locate the object
newBoxPolygon = transformPointsForward(tform, boxPolygon);
%%
figure; imshow(I); hold on;
line(newBoxPloygon(:,1), newBoxPloygon(:,2), 'Color', 'red', 'LineWidth',50);
title('Detected Object');