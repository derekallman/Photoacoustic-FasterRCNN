% Author: Derek Allman
% Date created: 9/13/2017
% Purpose: Simulate sources to add to point source bank

close all; clearvars -except p; clc;
addpath(genpath('~/MATLAB/k-Wave'));

% select save directory for reflection dataset
refLoc = uigetdir('../datasets/','Select which dataset to simulate.');
% destination for reflection labels and images

% create Images, Annotations, and ImageSets folder
if ~exist([refLoc '/data/Images'], 'dir')
    mkdir([refLoc '/data/Images']);
end
if ~exist([refLoc '/data/Annotations'], 'dir')
    mkdir([refLoc '/data/Annotations']);
end
if ~exist([refLoc '/data/ImageSets'], 'dir')
    mkdir([refLoc '/data/ImageSets']);
end

% load labels and simulation parameters
load([refLoc '/params.mat']);
load([chDatFID '/labels.mat']);
load([chDatFID '/params.mat']);

% randomize training folds
r = randperm(nIms);
train = r(1:floor(trainP*nIms));
test = r(floor(trainP*nIms)+1:nIms);

% create text files containing image indicies
testFID = fopen([refLoc '/data/ImageSets/test.txt'],'w');
fprintf(testFID,'%.6d\n',test);
fclose(testFID);

trainFID = fopen([refLoc '/data/ImageSets/train.txt'],'w');
fprintf(trainFID,'%.6d\n',train);
fclose(trainFID);

save([refLoc '/params.mat'],'test','train','-append');

% start parallel pool if not already running
p = gcp;

sLocList = cell(nIms,1);
rLocList = cell(nIms,1);
parforProgress(nIms)
parfor i = 1:nIms
    % if the image exists then skip the loop
    if exist([refLoc '/data/Images/' num2str(i,'%.6d') '.png'], 'file')
        parforProgress;
        continue
    end
    annoID = fopen([refLoc '/data/Annotations/' num2str(i,'%.6d') '.txt'],'w');
    
    im = zeros(4*numElements,Nt);
    c = labels(src{i}(1),1);
%     kgrid = makeGrid(Nx, dx, Ny, dy);
%     [kgrid.t_array, dt] = makeTime(kgrid, c);
%     dt = dt/(dx*1e4);
    for s = 1:length(src{i})
        sIdx = src{i}(s);
        
        % load source channel data and add to image
        channelFile = sprintf([chDatFID '/ChannelData/%06d.png'], sIdx);
        sChDat = double(imread(channelFile))';
        intensity = (maxIn-minIn).*rand(1) + minIn;
        im = im + intensity*sChDat;
        
        % get source location
        sLoc = [dy*labels(sIdx,3) labels(sIdx,4)]; % [dep lat]
        sLocList{i} = [sLocList{i}; sLoc];
        
        % write source annotation
        bbox = [4*(round(sLoc(2))-8), (sLoc(1)-.001)/c/dt, 4*(round(sLoc(2))+8),  (sLoc(1)+.001)/c/dt];
        neg = find(bbox < 0); bbox(neg) = 0;
        if bbox(2) > Nt bbox(2) = Nt; end
        if bbox(4) > Nt bbox(4) = Nt; end
        if bbox(1) > 4*numElements bbox(1) = 4*numElements; end;
        if bbox(3) > 4*numElements bbox(3) = 4*numElements; end;
        bbox = cast(round(bbox),'uint16');
        fprintf(annoID,'source %d %d %d %d\n',...
            bbox(1), bbox(2), bbox(3), bbox(4));
        for r = 1:length(ref{i})
            rIdx = ref{i}(r);
            
            % get reflector location
            rLoc = [dy*labels(rIdx,3) labels(rIdx,4)]; % [dep lat]
            rLocList{i} = [rLocList{i}; rLoc];
            
            % calculate Euclidean distance from source to artifact
            delta = sqrt(sum(([sLoc(1) sLoc(2)*(elWidth+elSpacing)*dx] - [rLoc(1) rLoc(2)*(elWidth+elSpacing)*dx]).^2));
            shift = round(delta/c/dt);
            
            % load source channel data and add to image
            channelFile = sprintf([chDatFID '/ChannelData/%06d.png'], rIdx);
            rChDat = double(imread(channelFile))';
            rChDat = circshift(rChDat,shift,2);
            rChDat(:,1:shift) = mode(rChDat(:));
            
            intensity = (maxIn-minIn).*rand(1) + minIn;
            im = im + intensity*rChDat;
            
            % write artifact annotation
            bbox = [4*(round(rLoc(2))-8), (rLoc(1)-.001)/c/dt+shift, 4*(round(rLoc(2))+8),  (rLoc(1)+.001)/c/dt+shift];
            neg = find(bbox < 0); bbox(neg) = 0;
            if bbox(2) > Nt bbox(2) = Nt; end
            if bbox(4) > Nt bbox(4) = Nt; end
            if bbox(1) > 4*numElements bbox(1) = 4*numElements; end;
            if bbox(3) > 4*numElements bbox(3) = 4*numElements; end;
            bbox = cast(round(bbox),'uint16');
            if bbox(2) ~= Nt
                fprintf(annoID,'artifact %d %d %d %d\n',...
                    bbox(1), bbox(2), bbox(3), bbox(4));
            end
        end
    end
    
    % scale image and save in ./folderID/Images
    noise = (maxNoise-minNoise).*rand(1) + minNoise;
    im = addNoise(im-mean(im(:)),noise);
    im = im - min(min(im));
    im = (im./max(max(im)));
    imwrite(im',[refLoc '/data/Images/' num2str(i,'%.6d') '.png']);
    fclose(annoID);
    parforProgress;

end
parforProgress(0);

% kill parallel pool
delete(p);
