function [epc_weight_matrix,sub_sec_index] = CovMatrixCom(seg_id, sec_id,sen_id,epc_dim,new_weight_matrix)

%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
SenNum = length(sen_id);
r_series = randperm(SenNum);
r_series = r_series(1,1:epc_dim);
sub_sec_id = sec_id(1,r_series);
sub_sec_id = sort(sub_sec_id);

sub_sec_index = [];
for i = 1:1:length(sub_sec_id)
    pos = find(seg_id == sub_sec_id(1,i));
    sub_sec_index = [sub_sec_index; pos];
end


epc_weight_matrix = new_weight_matrix(sub_sec_index,sub_sec_index);

end

