function new_data = DataExtraction(SenIDs, sen_eid, sec_id, saved_data)
%UNTITLED11 此处显示有关此函数的摘要
%   此处显示详细说明
slot_num = 96;
tar_col = length(sen_eid);
temp_pos = [];
for i = 1:1:tar_col
    pos = find(SenIDs == sen_eid(1,i));
    temp_pos = [temp_pos, pos];
end

disp('error.......')
sen_eid(1,38)

[row, col] = size(saved_data);
temp_mat = zeros(slot_num,tar_col);

for i = 1:1:col
    for j = 1:1:row
        temp_cell = saved_data(j,i);
        if isempty(temp_cell{1,1})
            empty_cell = {[]};
            saved_data(j,i) = empty_cell;
        else
            return_cell = ShrinkCell(temp_cell,temp_mat,temp_pos);
            saved_data(j,i) = return_cell;
        end
    end
end
new_data = saved_data;
end

