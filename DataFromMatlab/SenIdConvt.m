function [sensor_id, sensor_index] = SenIdConvt(SenIDs,copy_SenIDs)
%UNTITLED10 此处显示有关此函数的摘要
%   此处显示详细说明
sensor_id  = [];
sensor_index = [];
NumD = length(SenIDs);
load('SenConvert');

for i=1:1:NumD
    pos = find(copy_SenIDs==SenIDs(i));
    if isempty(pos)
        sensor_index = [sensor_index, i];
    end
end
FILL_GAP = 9999;
for j = 1:1:NumD
    pos = find(sensor_index == j);
    if isempty(pos)
        m = find(SenConvert(:,1) == SenIDs(j));
        sensor_id = [sensor_id,SenConvert(m,2)]; 
    else
        sensor_id = [sensor_id,FILL_GAP];
    end          
end


% % Prelocate for speed
% tempSenIDs = SenIDs; SenIDs = zeros(size(SenIDs));
% % Loop through the number of detectors for the IDs to be converted
% FILL_GAP = 9999;
% for n = 1:NumD
%    m = find(SenConvert(:,1)==tempSenIDs(n));
%    if isempty(m)
%        sensor_index = [sensor_index,n];
%        disp('sensor ID convert failure in SenIdConvt!');
%        sensor_id = [sensor_id,FILL_GAP]; 
%    else
%       sensor_id = [sensor_id,SenConvert(m,2)]; 
%    end
% %   SenIDs(n) = SenConvert(m,2);
% end
% sensor_index
% %sensor_id = SenIDs;

end

