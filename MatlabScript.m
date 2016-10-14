%% Clear
close all;
clear all;
clc;

%% load image
I2 = imread('001_backup.jpg');
%% Thresholding - Global Threshols
level = graythresh(I);
BW = im2bw(I, level);
%C = imfill(BW, 'holes');
%imshow(BW);
imshowpair(I, BW, 'montage');
% Edge Detection
%% Edge WT 1
sobel = edge(BW,'Sobel');
prewitt = edge(BW,'Prewitt');
imshowpair(sobel,prewitt,'montage')
%% Edge WT 2
roberts = edge(BW,'Roberts');
log = edge(BW,'log');
imshowpair(roberts,log,'montage')
%% Edge WT 3
canny = edge(BW,'canny');
imshowpair(canny,sobel,'montage')
%% Edge WT 4
BW2 = im2bw(I, 0.78);
edge_level = 0.06
canny1 = edge(BW,'canny', edge_level);
canny2 = edge(BW2,'canny', edge_level);
imshowpair(canny1, canny2, 'montage')
%% Segmentation
mask = zeros(size(BW));
mask(25:end-25,25:end-25) = 1;
%figure, imshow(mask);
segmented = activecontour(BW,mask,300,'edge');
figure, imshow(segmented);
title('Segmented Image');
%%
%I = imresize(I, 0.5);
level = graythresh(I);
T = adaptthresh(I(:,:,1),level);
%adapt = im2bw(I, T);
adapt = imbinarize(I(:,:,1), T);
cannyseg = edge(adapt,'canny');
imshowpair(adapt, cannyseg, 'montage')
figure
B = medfilt2(adapt);
imshow(B);
imsave
%%
B = medfilt2(I2(:,:,1));
level = graythresh(B);
T = adaptthresh(B(:,:,1),level);
adapt = imbinarize(B(:,:,1), T);
imshow(adapt);
imsave
%% Thresholding
levelm = multithresh(I);
seg_I = imquantize(I, levelm);
%C = imfill(BW, 'holes');
figure
imshow(seg_I,[]);
%imshowpair(img, BW, 'montage');
%%
[counts,x] = imhist(I,16);
stem(x,counts)
T = otsuthresh(counts);
BW2 = imbinarize(I,T);
figure
imshow(BW2);

%% Divide Channels
red = img(:,:,1);
green = img(:,:,2);
blue = img(:,:,3);
%%

BW1 = edge(BW,'canny');
trainedLanguage = 'E:\Semester 7\Subjects\Machine Vision\digits\ocroriginal\digitsofwatermeter\tessdata\digitsofwatermeter.traineddata';
results = ocr(BW, 'Language',trainedLanguage);
recognizedText = results.Text
imshowpair(BW, BW1, 'montage');
%imshow(BW);
text(600, 150, recognizedText, 'BackgroundColor', [1 1 1]);
%% Connected Components
BW = im2bw(img, 0.51);
SE = strel('square',10);
imopended = imopen(BW, SE);
imshowpair(BW, imopended, 'montage');
%%
CC = bwconncomp(BW);
%%
% Determine which is the largest component in the image and erase it (set
% all the pixels to 0).
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);
BW(CC.PixelIdxList{idx}) = 0;
%%
CC = bwconncomp(BW);
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);
BW(CC.PixelIdxList{idx}) = 0;
%%
%CC = bwconncomp(BW);
%numPixels = cellfun(@numel,CC.PixelIdxList);
%[biggest,idx] = max(numPixels);
%BW(CC.PixelIdxList{idx}) = 0;
%%
% Display the image, noting that the largest component happens to be the
% two consecutive f's in the word different. 
figure
results = ocr(BW);
results.Text
imshow(BW);
%'nearest'
%'bilinear'
%'bicubic'
%'box
%'triangle'
%%
J = imresize(BW, 0.5, 'bicubic');
%%
I2 = imcomplement(J);
%imshow(I2);

%%
results = ocr(img);
recognizedText = results.Text;
recognizedText
%imshow(I2);

%imfill(I2);
imshowpair(BW, img, 'montage');
text(600, 150, recognizedText, 'BackgroundColor', [1 1 1]);

%I = imread('5.jpg');
%[X MAP] = imread('5.jpg');
%RGB = ind2rgb(X,MAP);
%cform2lab = makecform('srgb2lab');
%LAB = applycform(RGB, cform2lab);
%figure, imshow(img)
%BW = imbinarize(img);
%img = imresize(img, 0.5, 'bicubic');
%imcontrast(gca)
%a = zeros(size(img, 1), size(img, 2));
%just_red = cat(3, red, a, a);
%figure, imshow(just_red)
%just_green = cat(3, a, green, a);
%figure, imshow(just_green)
%just_blue = cat(3, a, a, blue);
%figure, imshow(just_blue)