% Author: Derek Allman
% Date created: 9/13/2017
% Purpose: Simulate sources to add to point source bank

close all; clearvars -except p; clc;
addpath(genpath('~/MATLAB/k-Wave'));

% select which folder for dataset you would like to simulate
chDatFID = uigetdir; % folder containing proper labels for simulated sources

% create channel data folder
if ~exist([chDatFID '/ChannelData'], 'dir')
    mkdir([chDatFID '/ChannelData']);
end

% load labels and simulation parameters
load([chDatFID '/labels.mat']);
load([chDatFID '/params.mat']);

% start parallel pool if not already running
p = gcp;

loopLabels = unique(labels(:,1:3),'rows');

% Do the main loop in parallel
parforProgress(size(loopLabels,1));
parfor i = 1:size(loopLabels,1)
    data = loopLabels(i,:);  % avoid communication overhead with 'loopLabels'
    s = data(1);
    x = Nx/2;
    y = data(3);
    rad = data(2);
    
    % set some hard-coded parameters
    kgrid = makeGrid(Nx, dx, Ny, dy);
    
    % define initial pressure distrbution
    disc = mag*makeDisc(Nx, Ny, x, y, rad);
    p0 = smooth(kgrid, disc, true);
    
    % define sensor
    this_mask = zeros(Nx,Ny);
%     element = [ones(1,elWidth) zeros(1,elSpacing)];
%     aperture = repmat(element, 1, simElements);
    this_mask(:,1) = 1; %aperture;
    
    % simulate source in center of transducer
%     [kgrid.t_array, dt] = makeTime(kgrid, s);
%     dtSim = dt/(dx*1e4);
%     kgrid.t_array = kgrid.t_array(1:Nt);
    kgrid.t_array = dt*(1:Nt);
    input_args = {'PMLInside', false, 'PlotPML', false, 'Smooth', true,...
        'DataCast','gpuArray-single', 'PlotSim', false};
    sensorData = kspaceFirstOrder2D(kgrid, struct('sound_speed',s), ...
        struct('p0',p0), struct('mask',this_mask), input_args{:});
    sensorData = gather(sensorData);
    
    [X,Y] = meshgrid(1:size(sensorData,2),1:size(sensorData,1));
    [Xnew,Ynew] = meshgrid(1:Nt,1:1/upsampleFactor:size(sensorData,1));
    sensorDataUpsample = interp2(X,Y,sensorData,Xnew,Ynew,'cubic');    
    
    % shift channel data in x dimension to reduce time simulating
    for j = 1:length(xPos);
        % Set output file name and skip if already processed
        channelFile = sprintf([chDatFID '/ChannelData/%06d.png'], (i-1)*length(xPos)+j);
        if exist(channelFile, 'file')
            continue
        end
        windowedSensorData = sensorDataUpsample(upsampleFactor*((Nx/2-xPos(j)):(Nx/2-xPos(j))+apLength),1:Nt);
        windowedSensorData = imresize(windowedSensorData,[apLength,Nt]);
        windowedSensorData(elWidth+elSpacing:elWidth+elSpacing:end,:) = [];
        windowedSensorData = permute(reshape(windowedSensorData',Nt, elWidth, numElements),[3 1 2]);
        windowedSensorData = mean(windowedSensorData,3);
        windowedSensorData = windowedSensorData - min(min(windowedSensorData));
        windowedSensorData = (windowedSensorData./max(max(windowedSensorData)));
        windowedSensorData = permute(repmat(windowedSensorData,[1,1,4]),[3 1 2]);
        windowedSensorData = reshape(windowedSensorData, 4*numElements,Nt)';
        imwrite(windowedSensorData,channelFile);
    end
    parforProgress;
end
parforProgress(0);

% kill parallel pool
delete(p);