function [ loc ] = bbox2loc( bbox )
%BBOX2LOC Finds center of matlab bounding box from xywh coordinates

loc = [bbox(:,1)+0.5*bbox(:,3) bbox(:,2)+0.5*bbox(:,4)];

end

