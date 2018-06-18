close all; clc; clearvars;

setDefaults;

% select folder to find channel data
parentDir = uigetdir([],'Select folder containing channel data.');
chdatDir = [parentDir '/CHDAT'];
dataList = dir([chdatDir '/20*']);

% select which simulation this will be used with
networkDir = uigetdir('../../../output/faster_rcnn_end2end/','Select which network this will be used with.');
parts = strsplit(networkDir, '/');
net = strsplit(parts{end},'_');
net = strjoin(net(2:end-1),'_')

load(['../datasets/' net '/params.mat'])

id = strsplit(net,'_');
id = [id{1} '_' num2str(upsampleElement*numElements) '_' num2str(Nt)]

if ~exist([parentDir '/RFDAT_' id], 'dir')
    mkdir([parentDir '/RFDAT_' id]);
end
if ~exist([parentDir '/RFDAT_' id '/pres'])
    mkdir([parentDir '/RFDAT_' id '/pres'])
end

ind = 0;
for ii = 1:length(dataList)
    disp([num2str(ii) ': ' dataList(ii).name]);
    cd(chdatDir);
    cd(dataList(ii).name);
    
    files = dir('*layer*');
    fname = files(1,1).name;
    pname = [pwd '/'];
    
    load([pname 'Sequence.mat' ]);
    load([pname fname]);    
    
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
        
        tmp = double((Atmp(:,1:Nt)));
%         tmp = tmp - min(min(tmp));
%         tmp = (tmp./max(max(tmp)));
        tmp = permute(repmat(tmp,[1,1,upsampleElement]),[3 1 2]);
        tmp = reshape(tmp, upsampleElement*numElements,Nt)';
              
        filename = [parentDir '/RFDAT_' id '/' num2str(ind) '_' dataList(ii).name '_' num2str(jj) '.png'];
        imwrite(tmp,filename);
        c=1400;
        imagesc(linspace(0,38.4,512),(1:Nt)*c/40e6*1000,tmp);
        axis image;xlabel('Lateral Position [mm]');ylabel('Depth [mm]');colormap(gray);
        saveas(gcf,[parentDir '/RFDAT_' id '/pres/' num2str(ind) '_' dataList(ii).name '_' num2str(jj) '.png']);
    end
end
