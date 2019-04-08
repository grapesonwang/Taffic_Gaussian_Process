function [Cluster_cell] = LableXYExtraction(sen_eid, Sen_XY);
%UNTITLED9 此处显示有关此函数的摘要
%   此处显示详细说明
temp_seq = 1:1:length(sen_eid);
sen_lab_XY = [temp_seq; sen_eid; Sen_XY]; % row vector
cluster_lable = (xlsread('./Sensor_Location/cluster_lable.xlsx'))'; % col2row
center_idxs = (xlsread('./Sensor_Location/center_idxs.xlsx'))'; % col2row

[id_row, id_col] = size(center_idxs);
temp_cell = cell(id_row, id_col);
for i = 1:1:id_row
    for j = 1:1:id_col
        temp_data = sen_lab_XY(:,cluster_lable==j);
        temp_cell{i,j} = temp_data;
    end
end
Cluster_cell = temp_cell;
end

