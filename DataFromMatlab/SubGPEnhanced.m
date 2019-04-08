function [] = SubGPEnhanced(folder_name,common_index,seq_ID_mat)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

% clear all;
% clc
path_str = strcat('./ssdf_data/train_data/',folder_name,'/')
name_mat = xlsread(strcat(path_str,'name_mat.xlsx'));
[nam_row, nam_col] = size(name_mat);
disp(['Maximum training set can be used is ', num2str(nam_row)]);
tr_set_num = input('Input the number of sets to train GP:');
disp(['You input number is:',num2str(tr_set_num)]);
if (tr_set_num < 0) | (tr_set_num > nam_row)
    disp(['Input a number between ',num2str(0),' and ',num2str(nam_row)]);
end

%% Testing set  
test_data_path = ['./ssdf_data/test_data/' folder_name '/'] ;

disp(['Input a number shown as following ',num2str(common_index)]);
ts_set_num = input('Input the number of sets to test GP:');
disp(['You input number is:',num2str(ts_set_num)]);

temp_name = vec2str(ts_set_num,seq_ID_mat);
if ~exist(strcat(test_data_path,temp_name,'.xlsx'))
    disp('No testing data found!!!');
else
     test_set = xlsread(strcat(test_data_path,temp_name,'.xlsx'));
end

[c_row, c_col] = size(test_set);
step = 24;
x_start = 1;
x_end = c_col - 1;

[xs,ys] = DataPrep(test_set,step,x_start,x_end,c_col);

%% Time series testing data preparation

Y = [1:length(ys)]';
X = xs; 

%path = ['./ssdf_data./sub_result/' folder_name] ;  
savepath = ['./ssdf_data/sub_result/' folder_name] ;
%copyfile(path,savepath);
if ~exist(savepath)
   mkdir(savepath);
else
    rmdir(savepath,'s');
    mkdir(savepath);
end

%% Training set
for i = 1:1:nam_row
    temp_name_vec = name_mat(i,:)
    temp_name = vec2str_sim(temp_name_vec)
    temp_set = xlsread(strcat(path_str,temp_name,'.xlsx'));
    [t_row, t_col] = size(temp_set);
    [x,y] = DataPrep(temp_set,step,x_start,x_end,t_col);
    %[x,y] = train_test_xy(temp_set);
    clear temp_set;
    [pred,se,ci] = GpTrainTest(x,y,xs,ys,X,Y);
    res_mat = [ys pred ci se];
    xlswrite(strcat(strcat(savepath,'/',temp_name,'res'),'.xlsx'), res_mat, 'Sheet1');
end

end

