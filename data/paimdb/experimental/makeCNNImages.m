close all; clearvars; clc;

setDefaults;

dataset = './liver/';
network = 'L3-8_s1_r1';

detpath = [dataset 'cnn_output/' network '/dets/'];
savedir = [dataset 'cnn_output/' network '/cnn_mask/'];
if ~exist(savedir,'dir')
    mkdir(savedir);
end

files = dir([detpath '*.csv']);

sig = .14;
dt = 2.500e-08;
sos = 1420;
stop_d = 0.042;
stop = stop_d/sos/dt;

for i = 1:length(files)
    expIm = zeros(128,3328);
    imagesc(linspace(0,38.4,128),1000*linspace(dt*sos,stop_d,stop),expIm',[0,255]); colormap 'gray'; hold off;
    if files(i).bytes ~= 0
        det = csvread([detpath files(i).name]);
        numdets = size(det,1);
        xpos = mean([det(:,1) det(:,3)],2)/512*38.4;
        ypos = mean([det(:,2) det(:,4)],2)*dt*sos*1000;
        pos = [xpos-2*sig ypos-2*sig 4*sig*ones(numdets,1) 4*sig*ones(numdets,1)];
        expIm = zeros(128,3328);
        imagesc(linspace(0,38.4,128),1000*linspace(dt*sos,stop_d,stop),expIm',[0,255]); colormap 'gray'; hold off;
        text(pos(:,1)-6,pos(:,2)-2.5,'source','Color','red','FontSize',25)
        for j = 1:numdets  
            rectangle('Position', pos(j,:),'Curvature',[1 1],'FaceColor',[1 1 1]);
        end
    end
    axis image;xlabel('Lateral Position [mm]');ylabel('Depth [mm]');
    [~,strpname,~] = fileparts(files(i).name);
    saveas(gcf,[savedir strpname '.png']);
    
    clear det numdets xpos ypos pos 
end