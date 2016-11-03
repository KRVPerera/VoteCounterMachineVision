%%
I2 = imread('Signs/4.png');
I = rgb2gray(I2);
%imshow(I);
imageSegmenter(I2);