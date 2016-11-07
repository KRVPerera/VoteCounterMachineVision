%% Clear
close all;
clear all;
clc;

%%
I = imread('001p1.jpg');
%I2 = imresize(I, 0.5);
I2 = I;
%%
Ibw = ~OptimalThresholdedImage(I2);
Ifill = imfill(Ibw,'holes');
Iarea = bwareaopen(Ifill,100);
Ifinal = bwlabel(Iarea);
%%
stat = regionprops(Ifinal,'Area','MajorAxisLength','BoundingBox','Perimeter','Solidity');%,Perimeter,Solidity');
%%
%% Using Solidity|Area|BoundingBox
imshow(I2); hold on;
for cnt = 1 : numel(stat)
    bb = stat(cnt).BoundingBox;
    if stat(cnt).Area > mean(cat(stat.Area)) &&  stat(cnt).Solidity > mean(cat(1,stat.Solidity))
        %PossibleBox(stat(cnt))
        rectangle('position',bb,'edgecolor','r','linewidth',2);
    end
end