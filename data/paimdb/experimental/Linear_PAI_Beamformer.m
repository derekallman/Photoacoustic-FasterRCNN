% Clear workspace
clearvars;
close all;
clc;

% Select folder with Channel data
parentDir = uigetdir([],'Select folder containing channel data.');
chdatDir = [parentDir '/CHDAT'];
addpath(genpath(pwd));

cd(chdatDir) % -> in CHDAT
dataList = dir('20*');
mkdir([chdatDir '/../DAS'])
SaveDir = [ chdatDir '/../DAS'];
length(dataList)

% Iterate through all the folders and beamform the images
ind=0;
for ii = 1:length(dataList)
    disp([num2str(ii) ':' dataList(ii).name]);
    cd(chdatDir);
    cd(dataList(ii).name);

    fileList = dir('*layer*CUSTOMDATA*.mat');
    if size(fileList,1) == 0
        fileList = dir('*layer*DATA*.mat');
    end
    
    for jj = 1:length(fileList)
        ind = ind + 1;
        %Grab file name and path name to process
        fname = fileList(jj).name
        pname = [pwd '/'];
        seq = load([pname 'Sequence.mat']);
        chan = load([pname fname]);

        fileName = [num2str(ind) '_' dataList(ii).name '_' num2str(jj) '.png'];
        PA_Beamform(SaveDir, fileName, chdatDir, chan, seq);
    end
end
