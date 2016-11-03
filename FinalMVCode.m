%% Clear
close all;
clear all;
clc;
%% load images
I = imread('test1.jpg');
Igray = rgb2gray(I);
imshow(Igray);
%% Optimal Threshold for the image
adapt = OptimalThresholdedImage(I);
figure;imshow(adapt);