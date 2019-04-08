weight = xlsread('./matlab_with_R/embd_p/asy_mat_2R.xlsx');

sen_mat = xlsread('./ssdf_data/train_data/1_2_5_11_14_/sen_mat.xlsx');

[row, col] = size(sen_mat);

folder_name = 'accuracy_vs_weight';
savepath = ['./ssdf_data/' folder_name];
if ~exist(savepath)
    mkdir(savepath);
else
    rmdir(savepath,'s');
    mkdir(savepath);
end

for i = 1:1:row
    temp_sen = sen_mat(i,:);
    temp_weight = weight(temp_sen, temp_sen);
    file_name = vec2str_sim(temp_sen);
%     sheet  = 1;
%     xlRange = 'A1:E5';
%     path = strcat(strcat(savepath,'/',file_name),'.xlsx');
%     xlswrite(path,temp_weight,'Sheet1');
%     xlswrite(strcat(strcat(savepath,'/',file_name,'res'),'.xlsx'), temp_weight, 'Sheet1');
    xlswrite(strcat(strcat(savepath,'/',file_name),'.xlsx'),temp_weight,'Sheet1');
%      xlswrite(strcat(strcat(savepath,'/',file_name),'.xlsx'),temp_weight,sheet,xlRange);
    
    temp_sum_vec(i,:) = [sum(sum(temp_weight)) sum(temp_weight,1) (sum(temp_weight,2))'];
end


