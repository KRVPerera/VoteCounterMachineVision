
%% Function balletPaper
function [partyname, preference, prefCount, partyCount] = balletPaper(pathname,filename, handles)
    % Reading the ballet paper image from the given path and file name
    img = strcat(pathname,filename); 
    originalBallotImg = imread(img);
    % Variable initialization
    preferencevotes='';
    prefVote1='';
    prefVote2='';
    prefVote3='';
    prefVoteCount=0;
    %% Rotation Correction
    rotationCorrectedImg = FixRotation(originalBallotImg);
    %% Basic Segmentation
    [partyVoteRgn, PreferenceVoteArea] = BasicSegmentation(rotationCorrectedImg, 0);
    %-------------------- START UI CODE AREA1
    imshow(partyVoteRgn,'Parent',handles.axes1);
    imshow(PreferenceVoteArea,'Parent',handles.axes2);
    %-------------------- START UI CODE AREA1
    %% Resiszing the PartyVoteArea
    PartyVoteArea = imresize(partyVoteRgn, [1200 900], 'bicubic');
    %% Getting Dimentions
    [height,width,layers] = size(PartyVoteArea);
    display(height);
    display (width);
    %% Gray Scale
    grayBallotImg = rgb2gray(rotationCorrectedImg);
    %% Converting to Binary
    PartyVoteAreaBw = OptimalThresholdedImage(PartyVoteArea);
    %% Find The Vote Box
    [partyVoteCount, voteRect] = FindTheVotedBox(PartyVoteAreaBw, 0);
    %% Find The Voted Party
    pname = FindTheVotedPartyName(PartyVoteAreaBw, voteRect, 0);
    rectangle('position',[voteRect(1),voteRect(2),voteRect(3),voteRect(4)],'edgecolor','r','linewidth',1,'Parent',handles.axes1);
    
    %% Filter By Area To Find Preference Votes
%     test = rgb2gray(PreferenceVoteArea);
    binaryBallotImg=im2bw(grayBallotImg,0.6);
    areaFilteredBinaryBallotImg = bwareafilt(binaryBallotImg,[4000 9000]);
    %% Get Regional Properties
    regionProperties = regionprops(areaFilteredBinaryBallotImg, 'Area','BoundingBox');
    %% Fine The Preference Vote Boxes
    display(length(regionProperties))
    binaryImgWithCross=im2bw(grayBallotImg,0.8);
    %imshow(rotationCorrectedImg);hold on;
    for k = 1 : length(regionProperties)
        boundRect = regionProperties(k).BoundingBox;
        if (boundRect(4) <= 60) && (boundRect(3) <= 90) && (boundRect(2) > height/2)
            rect = int32([boundRect(1)+5,boundRect(2)+5,boundRect(3)-10,boundRect(4)-10]);  
            croppedImgWithoutCross = imcrop(binaryBallotImg,rect);
            croppedImgWithCross = imcrop( binaryImgWithCross,rect);
            
            % Calculate Invariant Moments
            invariantMoment_WithoutCross = GetSignRSTMoments(croppedImgWithoutCross);
            invariantMoment_WithCross = GetSignRSTMoments(croppedImgWithCross);

            difference=abs(invariantMoment_WithoutCross-invariantMoment_WithCross);
            
            if(difference>0.405)
                binaryBallotImgOCR=im2bw(grayBallotImg,0.5);
                croppedImgWithoutCross1 = imcrop(binaryBallotImgOCR,rect); 
                croppedImgWithoutCross =bwareaopen(~croppedImgWithoutCross1,50);
                results=ocr(croppedImgWithoutCross,'CharacterSet','0123456789','TextLayout','Block');
                preferencevotes=strcat(preferencevotes,results.Text);
                preferencevotes=strcat(preferencevotes,',');
                prefVoteCount=prefVoteCount+1;
                
                if(prefVoteCount==1)
                    prefVote1=boundRect;
                    prefVoteNo1=results.Text;
                end
                
                if(prefVoteCount==2)
                    prefVote2=boundRect;
                    prefVoteNo2=results.Text;
                end
                
                if(prefVoteCount==3)
                    prefVote3=boundRect;
                    prefVoteNo3=results.Text;
                end
                
                %rectangle('position',[boundRect(1),boundRect(2),boundRect(3),boundRect(4)],'edgecolor','r','LineWidth',1)
            
            end
        end
    end
    %%

    % Bounding boxes for the 3 marked preferences
    if(prefVoteCount<2)
        rectangle('position',[prefVote1(1),prefVote1(2),prefVote1(3),prefVote1(4)],'edgecolor','r','LineWidth',1);
    elseif(prefVoteCount<3)
        rectangle('position',[prefVote1(1),prefVote1(2),prefVote1(3),prefVote1(4)],'edgecolor','r','LineWidth',1);
        rectangle('position',[prefVote2(1),prefVote2(2),prefVote2(3),prefVote2(4)],'edgecolor','r','LineWidth',1);
    elseif(prefVoteCount<4)
        rectangle('position',[prefVote1(1),prefVote1(2),prefVote1(3),prefVote1(4)],'edgecolor','r','LineWidth',1);
        rectangle('position',[prefVote2(1),prefVote2(2),prefVote2(3),prefVote2(4)],'edgecolor','r','LineWidth',1);
        rectangle('position',[prefVote3(1),prefVote3(2),prefVote3(3),prefVote3(4)],'edgecolor','r','LineWidth',1);
    else
        
    end
    
    
%%
%h = msgbox(partyname);
%g = msgbox(preferencevotes);
partyname = pname;
preference= preferencevotes;
prefCount= prefVoteCount;
partyCount= partyVoteCount;


end


    