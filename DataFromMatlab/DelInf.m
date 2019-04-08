function [sec_id, sen_id, sen_eid, seg_id] = DelInf(sec_id, sen_id, sen_eid, seg_id, new_weight_matrix)
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明
ret_sec_index = [];
for i = 1:1:length(sec_id)
    pos = find(seg_id == sec_id(1,i));
    ret_sec_index = [ret_sec_index, pos];
end
test_col = new_weight_matrix(ret_sec_index,1);
Inf_col = find(test_col == Inf);

test_row = new_weight_matrix(1,ret_sec_index);
Inf_row = find(test_row == Inf);

Inf_num = [Inf_col,Inf_row];
Inf_num = unique(sort(Inf_num));

if ~isempty(Inf_num)
    sec_id(:,Inf_num) = [];
    sen_id(:,Inf_num) = [];
    sen_eid(:,Inf_num) = [];
end

%% delete segments that are not found form Observations in MainKriging
% sec_id_from_obsrv = xlsread('C:/Users/uos/Documents/Gaussian_Process/DataFromMatlab/section_id_vs_ID/sec_id_from_obsrv.xlsx','A1:KG1');
% obsrv_index_id = [];
% for i=1:1:length(sec_id)
%     pos = find(sec_id_from_obsrv == sec_id(1,i));
%     if isempty(pos)
%         obsrv_index_id = [obsrv_index_id,i];
%     end
% end
% 
% if ~isempty(obsrv_index_id)
%     sec_id(:,obsrv_index_id) = [];
%     sen_id(:,obsrv_index_id) = [];
% end

end

