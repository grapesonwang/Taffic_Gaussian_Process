function [] = SubTestData(test_data,seq_ID_mat, common_index,boundry,TIME_SLOT,SEN_NUM)
%UNTITLED15 此处显示有关此函数的摘要
%   此处显示详细说明
sub_test_num = length(common_index);
%expect_index = seq_ID_mat(2,common_index);
for i = 1:1:sub_test_num
    temp_index = common_index(1,i);
    fin_index = final_index(temp_index,boundry,TIME_SLOT,SEN_NUM);
    temp_data = test_data(fin_index,:);
    temp_name = vec2str(temp_index,seq_ID_mat);
    xlswrite(strcat(strcat('./ssdf_data/test_data/',temp_name),'.xlsx'), temp_data, 'Sheet1');
end

end

