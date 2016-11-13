function [partyVoteCount voteRect] = FindTheVotedBox(PartyVoteAreaBw, voteRect, DEBUG)

    if ~exist('debug','var')
        DEBUG = 0;
    end
    partyVoteCount = 0;
    [height, width, layers] = size(PartyVoteAreaBw);
    areaFilteredBinaryBallotImg = bwareafilt(PartyVoteAreaBw,[9046 14900]);%9046 14900
    %figure('Name','Vote Box','NumberTitle','off');
    %imshow(areaFilteredBinaryBallotImg);
    %title('Filtered Areas');
    %% Get Regional Properties
    regionProperties = regionprops(areaFilteredBinaryBallotImg, 'Area','BoundingBox');
    %% Find The Vote Boxes
    if DEBUG > 6
     figure('Name','rotationCorrectedImg Images party');
     imshow(PartyVoteArea);hold on;
    end
    for k = 1 : length(regionProperties)
      boundRect = regionProperties(k).BoundingBox;
      if (boundRect(4) <= 120) && (boundRect(1) > width/2)
        rect = int32([boundRect(1)+5,boundRect(2)+5,boundRect(3)-10,boundRect(4)-10]);  
        croppedImg = imcrop(areaFilteredBinaryBallotImg,rect); 
        if DEBUG > 6
            rectangle('position',boundRect,'edgecolor','r','linewidth',2);
        end
        croppedBwImg = im2bw(croppedImg, 0.8); % 0.8 is the luminance threshold
        %figure('Name','Cropped Images party','NumberTitle','off');
        %imshow(croppedBwImg);
        %conectedComponents = bwconncomp(croppedBwImg);
        numberOfPixels = numel(croppedBwImg);
        numberOfTruePixels = sum(croppedBwImg(:));
        if (numberOfPixels > numberOfTruePixels+20)
           %figure('Name','BW Cropped Images party','NumberTitle','off');
           %imshow(croppedBwImg);
           voteRect = boundRect;
           partyVoteCount= partyVoteCount+1;
          %display(voteRect);
        end
      end
    end
    if DEBUG > 6
        hold off;
    end
    if DEBUG > 3
        figure('Name','Detected Vote','NumberTitle','off');
        imshow(PartyVoteArea);
        rectangle('position',[voteRect(1),voteRect(2),voteRect(3),voteRect(4)],'edgecolor','r','LineWidth',1)
    end
end