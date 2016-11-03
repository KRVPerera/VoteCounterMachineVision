%%
I2 = imread('Signs/9.png');
I = rgb2gray(I2);
%I = imfill(I,'holes');
imshow(I)
hold on
title('Original Image');
% Specify initial contour location close to the object that is to be
% segmented.
mask = false(size(I));
mask(5:75,10:95) = true;
% Display the initial contour on the original image in blue.
visboundaries(mask,'Color','b'); 
%%
% Segment the image using the |'edge'| method and 200 iterations.
bw = activecontour(I, mask, 200, 'Chan-Vese');
%%
% Display the final contour on the original image in red.
visboundaries(bw,'Color','r'); 
title('Intial contour (blue) and final contour (red)');
% Display segmented image.
figure, imshow(bw)
title('Segmented Image');
