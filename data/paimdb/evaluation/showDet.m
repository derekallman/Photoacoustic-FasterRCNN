function [ ] = showDet( fn, srcDet, artDet )
%SHOWDET Show bounding boxes for given image.

Im = imread(fn);
[pathstr,name,ext] = fileparts(fn) ;
tmp = strsplit(pathstr,'/')
if strcmp(tmp{2},'hdd')
    tmp{7} = 'Annotations';
else
    tmp{8} = 'Annotations';
end
ext = '.txt';
annoFn = strjoin([tmp name],'/');
annoFn = strcat(annoFn, ext);

[srcGT, artGT] = parseAnno(annoFn);
imInd = str2num(name);

sDetInd = find(srcDet(:,1) == imInd);
aDetInd = find(artDet(:,1) == imInd);

Im2 = insertShape(Im,'Rectangle',[srcGT; srcDet(sDetInd,3:6)],...
    'Color', [repmat({'blue'},1,size(srcGT,1)),...
    repmat({'red'},1,size(sDetInd))]',...
    'LineWidth',2);
Im3 = insertShape(Im2,'Rectangle',[artGT; artDet(aDetInd,3:6)],...
    'Color', [repmat({'magenta'},1,size(artGT,1)),...
    repmat({'yellow'},1,size(aDetInd))]',...
    'LineWidth',2);
% imagesc(Im);  title(['Image = ' name]); colormap gray;
% junk = waitforbuttonpress;
% axis image;
imagesc(Im3); title(['Image = ' name]); colormap gray;
axis image;
% set(gca,'xtick',[])
% set(gca,'xticklabel',[])
% set(gca,'ytick',[])
% set(gca,'yticklabel',[])
end

