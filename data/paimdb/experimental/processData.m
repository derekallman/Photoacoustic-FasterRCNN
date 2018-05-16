close all; clc; clearvars;

setDefaults;

% select folder to find channel data
parentDir = uigetdir([],'Select folder containing channel data.');
chdatDir = [parentDir '/CHDAT'];
dataList = dir([chdatDir '/20*']);

% select which simulation this will be used with
simulationDir = uigetdir('../simulation','Select which simulation this will be used with.');
parts = strsplit(simulationDir, '/');
sim = parts{end};

if ~exist([parentDir '/RFDAT_' sim], 'dir')
    mkdir([parentDir '/RFDAT_' sim]);
end
if ~exist([parentDir '/RFDAT_view_' sim ])
    mkdir([parentDir '/RFDAT_view_' sim])
end

ind = 0;
for ii = 1:length(dataList)
    disp([num2str(ii) ': ' dataList(ii).name]);
    cd(chdatDir);
    cd(dataList(ii).name);
    
    %%%%CHECK%%%%%%
    files = dir('*layer*');
    fname = files(1,1).name;
    pname = [pwd '/'];
    
    load([pname 'Sequence.mat' ]);
    load([pname fname]);
    %%%%%%%%%%%%%%%
    
    simVars = load(['../../../../simulation/' sim '/params.mat']);
    
    fileList = dir('*layer*CUSTOMDATA*.mat');
    if size(fileList,1) == 0
        fileList = dir('*layer*DATA*.mat');
    end
    
    for jj = 1:length(fileList)
        load(fileList(jj).name)
        ind = ind + 1;
        
        Atmp2 = reshape(permute(AdcData_frame000, [1 3 2]),128, AlignedSampleNum);
        imagesc(Atmp2);colormap gray;
        for i = 1:size(Atmp2,2)
            Atmp(:,i) = Atmp2(:,i) - mean( Atmp2(:,i) );
        end
        
        tmp = double((Atmp(:,1:simVars.Nt)));
%         tmp = tmp - min(min(tmp));
%         tmp = (tmp./max(max(tmp)));
        tmp = permute(repmat(tmp,[1,1,4]),[3 1 2]);
        tmp = reshape(tmp, 4*simVars.numElements,simVars.Nt)';
              
        filename = [parentDir '/RFDAT_' sim '/' num2str(ind) '_' dataList(ii).name '_' num2str(jj) '.png'];
        imwrite(tmp,filename);
        c=1400;
        imagesc(linspace(0,38.4,512),(1:simVars.Nt)*c/40e6*1000,tmp,[0.35,0.6]);
        axis image;xlabel('Lateral Position [mm]');ylabel('Depth [mm]');colormap(gray);
        saveas(gcf,[parentDir '/RFDAT_view_' sim '/' num2str(ind) '_' dataList(ii).name '_' num2str(jj) '.png']);
    end
end
