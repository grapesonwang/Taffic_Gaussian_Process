%% This is originally of a copy of "PapTst_all.m"
clear all;
clc
%global tr_set_num
folder_name = '3_2_8_10_11_';
path_str = strcat('./ssdf_data/train_data/',folder_name,'/')
name_mat = xlsread(strcat(path_str,'name_mat.xlsx'));
[nam_row, nam_col] = size(name_mat);
disp(['Maximum training set can be used is ', num2str(nam_row)]);
tr_set_num = input('Input the number of sets to train GP:');
disp(['You input number is:',num2str(tr_set_num)]);
if (tr_set_num < 0) | (tr_set_num > nam_row)
    disp(['Input a number between ',num2str(0),' and ',num2str(nam_row)]);
end

%% Testing set  1_11.xlsx and 2_13.xlsx
sen_no_1 = xlsread('./ssdf_data/test_data/1_11_.xlsx');
sen_no_2 = xlsread('./ssdf_data/test_data/2_13_.xlsx');
[c_row, c_col] = size(sen_no_1);
step = 24;
x_start = 1;
x_end = c_col - 1;

disp(['Input a number between ',num2str(1),' and ',num2str(2)]);
ts_set_num = input('Input the number of sets to test GP:');
disp(['You input number is:',num2str(ts_set_num)]);
if ts_set_num == 1
    %[xs,ys] = train_test_xy(sen_no_1);
    [xs,ys] = DataPrep(sen_no_1,step,x_start,x_end,c_col);
else
    %[xs,ys] = train_test_xy(sen_no_2);
    [xs,ys] = DataPrep(sen_no_1,step,x_start,x_end,c_col);
end
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
    temp_name_vec = name_mat(i,:);
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

function [x,y] = train_test_xy(temp_set)
x = temp_set(:,end-1);
y = temp_set(:,end);
end















