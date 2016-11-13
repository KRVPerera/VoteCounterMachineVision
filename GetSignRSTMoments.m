function [moment] = GetSignRSTMoments(RGBimage0, debug)
    if ~exist('debug','var')
        debug = 0;
    end

    RGBimage = imresize(RGBimage0, [99 227]);
    
    if size(RGBimage,3)== 3        
        Igray = rgb2gray(RGBimage);
        level = graythresh(Igray);
        object = imbinarize(Igray, level);
    elseif size(RGBimage,3)== 2
        Igray = RGBimage0;
        level = graythresh(Igray);
        object = imbinarize(Igray, level);
    else
        object = RGBimage;
    end

    Icomp = imcomplement(object);
    Ifilled = imfill(Icomp,'holes');

    mask = false(size(object));
    mask(1:99,1:226) = true;
    %%
    if debug == 1
        imshow(Ifilled);hold on;
        visboundaries(mask,'Color','b'); 
    end
    %%
    % Segment the image using the |'edge'| method and 200 iterations.
    bw = activecontour(Ifilled, mask, 350, 'Chan-Vese'); %'Chan-Vese'
    if debug == 1
        visboundaries(bw,'Color','r');
        title('Intial contour (blue) and final contour (red)');
        hold off;
    end
    %%
    %large = imresize(bw, 2);
    largeE = edge(bw, 'canny');
    e_temp =  compute_eta(compute_m(largeE));
    invariantMoment_temp = e_temp.eta20 + e_temp.eta02;
    if debug == 1
        figure;imshow(largeE)
        title('Segmented Image');
    end
    moment = invariantMoment_temp;
end