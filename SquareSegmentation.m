%% Clear
close all;
clc;
imageName = '001m.jpg';
%%
I = imread(imageName);
%I2 = imresize(I, 0.5);
prefImName = strcat('Regions\Lower_',imageName,'.bmp');
upperImName = strcat('Regions\Upper_',imageName,'.bmp');
I2 = I;
%%
Ibw = ~OptimalThresholdedImage(I2);
Ifill = imfill(Ibw,'holes');
Iarea = bwareaopen(Ifill,100);
Ifinal = bwlabel(Iarea);
%% Getting overall properties to segment main regions
stat = regionprops(Ifinal,'Area','MajorAxisLength','BoundingBox','Perimeter','Solidity');

%% Using Solidity|Area|BoundingBox
regions = zeros(2,4);
regs = zeros(2);
%%
figure;imshow(I2); hold on;
title('Main regions');
index = 1;
for cnt = 1 : numel(stat)
    bb = stat(cnt).BoundingBox;
    if stat(cnt).Area > mean(cat(stat.Area)) &&  stat(cnt).Solidity > mean(cat(1,stat.Solidity))
        %PossibleBox(stat(cnt))
        regs(index) = cnt;
        regions(index,:)= bb;
        index = index + 1;
        rectangle('position',bb,'edgecolor','r','linewidth',2);
    end
end
%% Cropping Regions
if stat(regs(1)).Area > stat(regs(2)).Area
    region1_big = imcrop(Ibw, regions(1,:));
    region2_big = imcrop(Ibw, regions(2,:));
else
    region1_big = imcrop(Ibw, regions(2,:));
    region2_big = imcrop(Ibw, regions(1,:));
end
%% Resizing upper region to standard
% region1 = imresize(region1_big, [1200 900]);
% imwrite(region1,upperImName); % saving in a file
% 
% IfinalR1 = bwlabel(region1);
% stat1 = regionprops(IfinalR1,'Area','FilledArea','EulerNumber','BoundingBox','Perimeter','Solidity');
% muR1 = mean(cat(1,stat1.Area));
% sigmaR1 = std(cat(1,stat1.Area));
% 
% %
% %figure;imshow(IfinalR1); hold on;
% title('Region 1');
% for cnt = 1 : numel(stat1)
%     bb = stat1(cnt).BoundingBox;
%     if abs(stat1(cnt).Area-muR1) < 3*sigmaR1;%stat1(cnt).Area > mean(cat(stat1.Area)) &&  stat1(cnt).Solidity > mean(cat(1,stat1.Solidity))
%         %PossibleBox(stat(cnt))
%      %   regions(index,:)= bb;
%       %  index = index + 1;
%        % rectangle('position',bb,'edgecolor','r','linewidth',2);
%     end
% end
%% Resizing lower region
region2 = imresize(region2_big, [230 900]);
%region2 = imread(prefImName);
%imwrite(region2, prefImName);
region2e = edge(region2,'Canny');
IfinalR2 = bwlabel(region2e);

%stat2 = regionprops(IfinalR2,'Area','FilledArea','EulerNumber','BoundingBox','Perimeter','Solidity');
stat2 = regionprops(IfinalR2,'All');
muR2 = mean(cat(1,stat2.Area));
sigmaR2 = std(cat(1,stat2.Area));
%%
figure;imshow(IfinalR2); hold on;
index = 0
lisi = zeros(200,12);
T = clusterdata(lisi,'maxclust',5,'linkage','centroid');
for cnt = 1 : numel(stat2)
    bb = stat2(cnt).BoundingBox;
    if abs(stat2(cnt).Area-muR2) < 3*sigmaR2; % outlier removal
        %PossibleBox(stat(cnt))
     %   regions(index,:)= bb;
        index = index + 1;
      if index <  200
         lisi(index) = index;
         lisi(index,2) = stat2(cnt).Area;
         lisi(index,3) = stat2(cnt).Perimeter;
         lisi(index,4) = stat2(cnt).PerimeterOld;
         lisi(index,5) = stat2(cnt).Extent;
         lisi(index,6) = stat2(cnt).Solidity;
         lisi(index,7) = stat2(cnt).EquivDiameter;
        %lisi(index,8) = stat2(cnt).Extrema;
         lisi(index,8) = stat2(cnt).EulerNumber;
         lisi(index,9) = stat2(cnt).ConvexArea;
         lisi(index,10) = stat2(cnt).Eccentricity;
         lisi(index,11) = stat2(cnt).MinorAxisLength;
         lisi(index,12) = stat2(cnt).FilledArea;
         if find(find(T==1)==index )
            rectangle('position',bb,'edgecolor','m','linewidth',2, 'LineStyle','-');
         elseif find(find(T==2)==index )
            rectangle('position',bb,'edgecolor','r','linewidth',2, 'LineStyle','-');
         elseif find(find(T==3)==index )
            rectangle('position',bb,'edgecolor','g','linewidth',2, 'LineStyle','-');
         elseif find(find(T==4)==index )
            rectangle('position',bb,'edgecolor','b','linewidth',2, 'LineStyle','-');
         else
             stat2(cnt).Area
             rectangle('position',bb,'edgecolor','y','linewidth',2);
         end
      end
    end
end

for i=1:5
    find(T==i)
end
