I = imread('numbers.png');
In = imnoise(I, 'salt & pepper');
figure;
imshowpair(I, In, 'montage');

%% rgbBlock=imread('peppers.png');
cform = makecform('srgb2lab');
lab = applycform(I, cform); 
L_channel = lab(:,:,1);
A_channel = lab(:,:,2);
B_channel = lab(:,:,3);
L_channelNew = L_channel*1.5;
A_channelNew = A_channel*0.5;
B_channelNew = B_channel*0.5;
%% Filters
medianFilter = vision.MedianFilter([5 5]);
%% Filtering
figure;
L_channel = step(medianFilter, L_channel);
imshowpair(I, I_filtered, 'montage');
%% Show image
labNew = cat(3, L_channelNew, A_channelNew, B_channelNew);
cform2 = makecform('lab2srgb');
rgbNew = applycform(labNew,cform2);
%imshow(rgbNew);
