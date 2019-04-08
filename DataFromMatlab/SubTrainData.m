function [] = SubTrainData(train_data,seq_ID_mat,sub_train_num,...
                           common_index,diff_index_num,boundry,...
                           TIME_SLOT,SEN_NUM)
%UNTITLED13 此处显示有关此函数的摘要
%   此处显示详细说明
remain_index = setdiff(seq_ID_mat(1,:),common_index);
k_subset = nchoosek(remain_index,diff_index_num);
rand_order = randperm(length(k_subset));
expect_order = rand_order(1:sub_train_num);
expect_index = k_subset(expect_order,:);
fold_name = vec2str_sim([common_index expect_index(1,:)]);

seq_mat = [];
sen_mat = [];
name_mat = [];
temp_mat = [];

for i = 1:1:sub_train_num
    seq_vec = [common_index expect_index(i,:)];
    sen_vec = seq_ID_mat(2,seq_vec);
    seq_mat = [seq_mat; seq_vec];
    sen_mat = [sen_mat; sen_vec];
    name_vec = [];
    for j = 1:1:length(sen_vec)
        name_vec = [name_vec [seq_vec(1,j) sen_vec(1,j)]];
    end
    name_mat = [name_mat; name_vec];
end

% path = ['./ssdf_data./train_data/' fold_name] ;  
savepath = ['./ssdf_data/train_data/' fold_name] ;
% copyfile(path,savepath);
% savepath = ['./ssdf_data/sub_result/' folder_name] ;
%copyfile(path,savepath);
if ~exist(savepath)
   mkdir(savepath);
else
    rmdir(savepath,'s');
    mkdir(savepath);
end

xlswrite(strcat(strcat('./ssdf_data/train_data/',fold_name,'/name_mat'),'.xlsx'), name_mat, 'Sheet1');
xlswrite(strcat(strcat('./ssdf_data/train_data/',fold_name,'/seq_mat'),'.xlsx'), seq_mat, 'Sheet1');
xlswrite(strcat(strcat('./ssdf_data/train_data/',fold_name,'/sen_mat'),'.xlsx'), sen_mat, 'Sheet1');

for i = 1:1:sub_train_num
    temp_index = [common_index expect_index(i,:)];
    temp_index = sort(temp_index);
    fin_index = final_index(temp_index,boundry,TIME_SLOT,SEN_NUM);
    temp_data = train_data(fin_index,:);
    temp_name = vec2str(temp_index,seq_ID_mat);
    xlswrite(strcat(strcat('./ssdf_data/train_data/',fold_name,'/',temp_name),'.xlsx'), temp_data, 'Sheet1');
end
end




