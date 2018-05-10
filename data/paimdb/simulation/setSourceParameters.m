% Author: Derek Allman
% Date created: 9/13/2017
% Purpose: This script contains all of the parameters which
% will be used in the process of simulating a point source bank. 

close all; clearvars; clc;

chDatFID = 'L3-8';  % name of folder for source channel data, labels as 
                    % well as synthetic reflection images and their labels
                    
if exist('.gitignore', 'file')
    fid = fopen('.gitignore','a');
    fprintf(fid, '%s/\n', chDatFID);
    fclose(fid);
else
    fid = fopen('.gitignore','w');
    fprintf(fid, '%s/\n', chDatFID);
    fclose(fid);
end
                    
if ~exist(chDatFID, 'dir')
    mkdir(chDatFID);
end

dx = 0.06e-3;       % grid point size x [mm]
dy = 0.1e-3;        % grid point size y [mm]
Nx = round(0.09/dx);          % imaging aperture length, allows deeper channel data
                    % used in simulation only(~20pts/mm) [grid points]
Ny = 255;          % depth simulated [grid points]
Nt = 1200;          % time steps to simulate
dt = 1/(40e6);      % 1/sampling frequency

% simElements = 300;    % total number of transducer elements
elWidth = round(0.00024/dx);       % width of each element [grid points]
elSpacing = round(0.00006/dx);     % spacing (kerf width) between the elements [grid points]
numElements = 128;              
apLength = numElements * elWidth + (numElements - 1) * elSpacing; % [grid points]
apWidth = apLength * dx;    % [mm]

sos = 1440:6:1640;  % [m/s]
xPos = round((1/6:1/120:5/6)*apWidth/dx);  % simulated lateral positions [grid points]
yPos = round((.005:.005:.025)/dy);  % simulated depth positions [grid points]
rad = round((.0001:.0001:.0001)/dx);        % simualted source sizes [grid points]
mag = 3;            % source magnitude
upsampleFactor = 2; % for spacing in xPos finer than 1 grid point, 
                    % use this to achieve proper placement of wavefront
                    % ex. if increment is 2.5 grid points use 2, if
                    % increment is 3.25 grid points use 4


% Create params.mat
save([chDatFID '/params.mat']);

% Create file for channel data labels
fprintf('Creating parameters up-front...');
labels = zeros(length(sos)*length(xPos)*length(yPos)*length(rad),4);
i=1;
for s = sos
    for rad = rad
        for y = yPos
            for  x = xPos
                labels(i,:) = [s, rad, y, round(x/(elWidth+elSpacing))];
                i=i+1;
            end
        end
        
    end
end
labels(i:end,:) = [];  % remove empty entries
fprintf('...done.\n');
save([chDatFID '/labels.mat'],'labels');