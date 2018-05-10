% Author: Derek Allman
% Date created: 9/13/2017
% Purpose: Simulate sources to add to point source bank

clear all; close all; clc;

setDefaults;

% select test dataset to evaluate
datapath = uigetdir('../../paimdb/datasets/','Select which test dataset to evaluate.');

% load in source and artifact labels and parameters
load([datapath '/params.mat'],'chDatFID','nIms','test','train','c');

addpath(genpath([datapath '/data']),...
    genpath([datapath '/results']),...
    genpath('~/MATLAB/k-Wave'));

% select network tested to evaluate
detFID = uigetfile([datapath '/results/faster_rcnn/*.txt'],...
    'Select which network tested to evaluate.');
tmp = strsplit(detFID,'_');
detFID = strjoin(tmp(1:length(tmp)-1),'_'); clear tmp;
outfile = [datapath '/outfile_' detFID '.mat'];

% load opject detections
class = struct('name',{{'source'},{'artifact'}},'num',0,'missed',0);
class(1).det = dlmread([detFID '_source.txt'], ' ');
class(1).det(:,3:6) = anno2xywh(class(1).det(:,3:6));
class(2).det = dlmread([detFID '_artifact.txt'], ' ');
class(2).det(:,3:6) = anno2xywh(class(2).det(:,3:6));

% initialize output file
if exist(outfile,'file')
    save(outfile,'class', '-append');
else
    save(outfile,'class');
end

% set hyperparameters
IoUThresh = 0.5;
beamform = 0;
showBoxes = 0;

% setup kWave portion
load(['../simulation/' chDatFID '/params.mat'],'Nx','Ny','dx','dy','apLength','dt');
trans = false;
if exist('dt','var')
    trans = true;
end
kgrid = makeGrid(Nx,dx,Ny,dy);

% get sample image to get dimensions
imread([datapath '/data/Images/000001.png']);
dim = size(ans);

% loop over all test images
numS = 0;
numA = 0;
for i = 1:length(test)
    % determine image index
    imInd = test(i);
    
    sos = c(imInd);
    chat(i) = sos;
    if trans == false
        [kgrid.t_array dt] = makeTime(kgrid, sos);
    end
    
    % parse test image annotation to find source (GT{1}) and artifact
    % (GT{2}) ground truth bounding boxes
    [GT{1}, GT{2}] = parseAnno([datapath '/data/Annotations/' num2str(imInd,'%.6d') '.txt']);
    if ~isempty(GT{2})
        saOverlap = bboxOverlapRatio(GT{1}, GT{2});
        saOverlap = saOverlap > IoUThresh;
        noArt = 0;
    end
    
    % loop over classes, 1: sources, 2: artifacts
    for j = 1:2
        if j == 1 opp = 2; else opp = 1; end
        class(j).num = class(j).num + size(GT{j},1);
        % find detections indicies corresponding to test image, i, of
        % class, j.
        detInd = find(class(j).det(:,1) == imInd);
        % loop over number of detections for class, j, of image, i.
        for k = 1:length(detInd)
            % define ground truth bounding boxes for class, j.
            BB = GT{j};
            if isempty(BB) % if no objects of class,j.
                class(j).IoU{detInd(k)} = [];
                class(j).gtIdx(detInd(k)) = 0;
            else
                class(j).IoU{detInd(k)} = bboxOverlapRatio(class(j).det(detInd(k),3:6),BB);
                [mIoU, class(j).gtIdx(detInd(k))] = max(class(j).IoU{detInd(k)});
                if mIoU < IoUThresh % if det does not overlap w/ pos class
                    class(j).gtIdx(detInd(k)) = 0;
                end
            end
            % create ignore condition for cases in which source and
            % artifact overlap in ground truth
            if noArt == 1 || class(j).gtIdx(detInd(k)) == 0
                class(j).ignore(detInd(k)) = 0;
            else
                if sum(saOverlap(class(j).gtIdx(detInd(k)),:)) ~= 0
                    class(j).ignore(detInd(k)) = 1;
                else
                    class(j).ignore(detInd(k)) = 0;
                end
            end
            
            % find distance errors
            if class(j).gtIdx(detInd(k)) == 0
                class(j).error(detInd(k),:) = [inf inf];
            else
                loc = bbox2loc(GT{j});
                err = loc(class(j).gtIdx(detInd(k)),:) - bbox2loc(class(j).det(detInd(k),3:6));
%                 err(1) = err(1)/10;
                err(1) = err(1)*apLength*dx/dim(2)*1000;
                err(2) = err(2)*sos*dt*1000;
                class(j).error(detInd(k),:) = err;
            end
            
            % do the same thing for the opposite class
            BBOpp = GT{opp};
            if isempty(BBOpp) % if no objects of class opp,j.
                class(j).IoUOpp{detInd(k)} = [];
                class(j).gtIdxOpp(detInd(k)) = 0;
            else
                class(j).IoUOpp{detInd(k)} = bboxOverlapRatio(class(j).det(detInd(k),3:6),BBOpp);
                [mIoU, class(j).gtIdxOpp(detInd(k))] = max(class(j).IoUOpp{detInd(k)});
                if mIoU < IoUThresh
                    class(j).gtIdxOpp(detInd(k)) = 0;
                end
            end
        end
        class(j).missed = class(j).missed + (size(GT{j},1) - nnz(unique(class(j).gtIdx(detInd))));
        saOverlap = saOverlap';
    end
    
    % (optional) visualize detections
    if showBoxes
        showDet([datapath '/data/Images/' num2str(imInd,'%.6d') '.png'], class(1).det, class(2).det);
        trash = waitforbuttonpress;
    end
end


% find optimal score threshold
for i = 1:2
    class(i).overlap = ones(1,length(class(i).gtIdx));
    class(i).overlap(class(i).gtIdx == 0) = 0;
    class(i).overlapOpp = ones(1,length(class(i).gtIdxOpp));
    class(i).overlapOpp(class(i).gtIdxOpp == 0) = 0;
    
    [class(i).rocX,class(i).rocY,class(i).rocT,class(i).AUC,opt] = perfcurve(class(i).overlap,class(i).det(:,2)',1);
    find(class(i).rocX == opt(1) & class(i).rocY == opt(2));
    class(i).scoreThresh = class(i).rocT(ans);
    
    class(i).acc = sum(class(i).overlap'.*(class(i).det(:,2) > class(i).scoreThresh))/class(i).num;
    class(i).missclass = sum(class(i).overlapOpp'.*(class(i).det(:,2) > class(i).scoreThresh))/class(i).num;
    class(i).missclassOver = sum(~class(i).ignore'.*class(i).overlapOpp'.*(class(i).det(:,2) > class(i).scoreThresh))/class(i).num;
    
    class(i).missDet = class(i).missed/class(i).num;
    
    class(i).recall = class(i).acc;
    class(i).precision = sum(class(i).overlap'.*(class(i).det(:,2) > class(i).scoreThresh))/sum(class(i).det(:,2) > class(i).scoreThresh);
end

save(outfile,'class', '-append');
