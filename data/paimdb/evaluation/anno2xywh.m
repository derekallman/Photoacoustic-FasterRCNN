function [ out ] = anno2xywh( anno )
%ANNO2XYWH Converts Faster-RCNN style bounding box annotations to MATLAB
%style
out = [anno(:,1:2)  anno(:,3)-anno(:,1) anno(:,4)-anno(:,2)];
end

