function [pName, partyRect] = FindTheVotedPartyName(PartyVoteAreaBw, voteRect, debug)

    if ~exist('debug','var')
        debug = 0;
    end
    
    areaFilteredBinaryBallotImg = bwareafilt(PartyVoteAreaBw,[16000 25000]);
    if debug
        figure('Name','Party Images','NumberTitle','off');
        imshow(areaFilteredBinaryBallotImg);hold on;
    end
    %% Get Regional Properties
    regionProperties = regionprops(areaFilteredBinaryBallotImg, 'Area','BoundingBox');
    %% Finding The Party
    % the folder in which ur images exists
    srcFiles = dir('.\+partyicons\*.png');
    pName = 'Unknown';
    for k = 1 : length(regionProperties)
        boundRect = regionProperties(k).BoundingBox; 

        if ( abs(boundRect(2)- voteRect(2)) < 10)
            partyRect = boundRect;
            rect = int32([boundRect(1)+5,boundRect(2)+5,boundRect(3)-10,boundRect(4)-10]);
            if debug
                rectangle('position',boundRect,'edgecolor','c','LineWidth',1);
                hold off;
            end
            croppedImg = imcrop(areaFilteredBinaryBallotImg,rect);
            invariantMoment = GetSignRSTMoments(croppedImg);
            
            % Find the sign has the minimum moment difference
            
            mindistance=10000;
            for i = 1 : length(srcFiles)
                    filename = strcat('.\+partyicons\',srcFiles(i).name);
                    iconRow = imread(filename);

                    invariantMoment_temp = GetSignRSTMoments(iconRow);
                 if ( abs(invariantMoment-invariantMoment_temp) < mindistance )
                     mindistance =abs(invariantMoment-invariantMoment_temp);
                     pName=srcFiles(i).name;
                 end                 
            end
          
        end
    end
    
    if debug
        figure('Name','Detected Party and Vote','NumberTitle','off');
        imshow(PartyVoteAreaBw);%partyVoteRgn
        rectangle('position',[voteRect(1),voteRect(2),voteRect(3),voteRect(4)],'edgecolor','r','LineWidth',1)
        rectangle('position',[partyRect(1),partyRect(2),partyRect(3),partyRect(4)],'edgecolor','g','LineWidth',1)
    end
end