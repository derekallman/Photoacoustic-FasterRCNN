% Author: Derek Allman
% Date created: 9/13/2017
% Purpose: Simulate sources to add to point source bank

close all; clearvars -except p; clc;

% select folder for channel data which will be used
chDatFID = uigetdir([],'Select folder containing source channel data to use.'); 
                    % folder containing proper labels for simulated sources

% create save directory for reflection dataset
refFID = 'test';
refLoc = ['../datasets/' refFID];

if exist('../datasets/.gitignore', 'file')
    fid = fopen('../datasets/.gitignore','a');
    fprintf(fid, '%s/\n', refFID);
    fclose(fid);
else
    fid = fopen('../datasets/.gitignore','w');
    fprintf(fid, '%s/\n', refFID);
    fclose(fid);
end

if ~exist([refLoc '/results/faster_rcnn'], 'dir')
    mkdir([refLoc '/results/faster_rcnn']);
end

% load labels and simulation parameters
load([chDatFID '/labels.mat']);
load([chDatFID '/params.mat']);

nIms = 200;   % number of images in dataset

% set percentage of images used to train
trainP = 0.8;        % [%]
testP = 1 - trainP ; % [%]

minSrc = 1; % minimum number of sources 
maxSrc = 1; % maximum number of sources
minRef = 1; % minumum number of reflectors
maxRef = 1; % maximum number of reflectors
% note number of reflection artifacts equals (# reflectors x # sources)

minIn = 1.1; % maximum intensity scaling factor
maxIn = .75; % minimum intensity scaling factor

maxNoise = 2;   % [dB]
minNoise = -5;  % [dB]

nSos = length(sos); % number of speeds of sounds considered

% start parallel pool if not already running
p = gcp;

parforProgress(nIms)
parfor i = 1:nIms
    % select speed of sound such that all are equally represented
    s = sos(mod(i,(nSos))+1);
    
    % define number of sources & reflectors
    nSrc = randi([minSrc maxSrc]);
    nRef = randi([minRef maxRef]);
    
    % randomly select source and reflector locations from list 'labels'
    % save the index of that location in 'src' and 'ref' respectively
    ind = find(labels(:,1) == s);
    r = randperm(length(ind));
    src{i} = ind(r(1:nSrc));
    ref{i} = ind(r(nSrc+1:nSrc+nRef)); 
    c(i) = s;
    parforProgress;
end
parforProgress(0);

save([refLoc '/params.mat'],'nIms','minSrc','maxSrc','minRef','maxRef',...
    'minIn','maxIn','src','ref','refFID','chDatFID','c','minNoise','maxNoise','trainP','testP');

% kill parallel pool
delete(p);
