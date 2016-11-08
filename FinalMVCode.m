%% Clear
close all;
%fclose all;
clear all;
clc;
%%%
% ALL (highest)
% TRACE
% DEBUG
% INFO (default)
% WARNING
% ERROR
% CRITICAL
% OFF (lowest)
%%%
addpath('E:\Semester 7\Subjects\Machine Vision\ImageBank_BaletPapers');
logger = logging.getLogger('BalletLogger');
logger.setLogLevel(logging.logging.ALL);
DEBUG_LEVEL = logging.logging.ALL;
%% load images
I = imread('001.jpg');
%Igray = rgb2gray(I);
%% Optimal Threshold for the image
%adapt = OptimalThresholdedImage(I);
%figure;imshow(adapt);
%% Breaking down to two main regions
[partyVoteRgn prefVoteRgn]= BasicSegmentation2(I);
%figure;imshowpair(partyVoteRgn, prefVoteRgn, 'montage');title('Regions');

%% Get preference votes
prefVotes = ExtractPrefVotes(prefVoteRgn,'Debug', DEBUG_LEVEL, 'UseEdge', 1);
%%
%aa = ocr(prefVoteRgn);
%% Get the party
%partyVote = ExtractPartyVote(partyVoteRgn);