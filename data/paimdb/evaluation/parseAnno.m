function [ srcGT, artGT ] = parseAnno( fn )
%PARSEANNO Parses annotation files from the Faster-RCNN labels

srcGT = [];
artGT = [];
fileID = fopen(fn, 'r');
lines = textscan(fileID,'%s','Delimiter','\n');
for i = 1:length(lines{1})
    a = textscan(lines{1}{i},'%s %f %f %f %f ');
    tmp = [a{2:5}];
    tmp = anno2xywh(tmp);
    if strcmp(a{1},'source')
        srcGT = [srcGT ; tmp];
    else
        artGT = [artGT ; tmp];
    end
end

fclose(fileID);

end

