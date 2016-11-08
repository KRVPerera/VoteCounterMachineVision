%%
% 1 - Bulath Kole, 2 - Bell, 3 - Bicycle, 4 - Elephant, 5 - Hakgediya, 
% 6 - Swan, 7 - House, 8 - Round Flagged Sign, 9 - Tree, 10 - Wheel
I2 = imread('Signs/10.png');
Is = imresize(I2, [92 147]);
I = rgb2gray(Is);
%I = imfill(I,'holes');
% imshow(I)
% hold on
% title('Original Image');
% Specify initial contour location close to the object that is to be
% segmented.
mask = false(size(I));
mask(4:90,6:146) = true;
% Display the initial contour on the original image in blue.
% visboundaries(mask,'Color','b'); 
%%
% Segment the image using the |'edge'| method and 200 iterations.
bw = activecontour(I, mask, 330, 'Chan-Vese');
%
% Display the final contour on the original image in red.
% visboundaries(bw,'Color','r'); hold off;
%title('Intial contour (blue) and final contour (red)');
% Display segmented image.
filterdI = medfilt2(bw);
large = imresize(filterdI, 2);
largeE = edge(large, 'canny');
imshow(largeE)
title('Segmented Image');

