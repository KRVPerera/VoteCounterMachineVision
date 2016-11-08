function [prefVotes] = ExtractPrefVotes(prefVoteRgn1, varargin)
    
    pnames = {'UseEdge','Debug'};
    deflts = { 0, 0};
    [useedge, debug] = internal.stats.parseArgs(pnames, deflts, varargin{:});
    %st = sprintf('%d',size(prefVoteRgn1));
    logger = logging.getLogger('ExtractPrefVotes',struct('path', './tmp/ExtractPrefVotes.log')) ;
    logger.setLogLevel(logging.logging.ALL);
    logger.debug('stkhjkhj');
    
    prefVotes = prefVoteRgn1;
 
    if useedge
        prefVoteRgn = edge(prefVoteRgn1,'log');
    else
        prefVoteRgn = prefVoteRgn1;
    end

    if debug < logging.logging.INFO
        figure;title('Input Region');imshow(prefVoteRgn);hold on;
        %or = ocr(prefVoteRgn);
        %for c = 1:numel(or.CharacterConfidences)
        %    rectangle('position',or.CharacterBoundingBoxes(c,:),'edgecolor','r','linewidth',2);
        %end
        hold off;
    end
%% Resizing lower region
region2 = imresize(prefVoteRgn, [230 900]);
IfinalR2 = bwlabel(region2);
stat2 = regionprops(IfinalR2, 'Area','FilledArea','EulerNumber','BoundingBox','Perimeter','Solidity');
muR2 = mean(cat(1,stat2.Area));
sigmaR2 = std(cat(1,stat2.Area));
%%
if debug < logging.logging.INFO
    figure;imshow(IfinalR2); hold on;
end

regions = zeros(40,4);
index = 1;

for cnt = 1 : numel(stat2)
    bb = stat2(cnt).BoundingBox;
    if abs(stat2(cnt).Area-muR2) < 3*sigmaR2; % outlier removal
      regions(index,:)= bb;
        
      if debug < logging.logging.INFO
        rectangle('position',bb,'edgecolor','r','linewidth',1);
      end
      index = index + 1;
    end
end
end