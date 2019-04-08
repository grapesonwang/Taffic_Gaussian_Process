%% This is originally a copy of "GP_TrFiPr.m"
clear all;
clc


%% Training/Testing set  1_11.xlsx and 2_13.xlsx
% Same name but in different folders
train_no_1 = xlsread('./ssdf_data/sin_train_data/1_11_.xlsx');
train_no_2 = xlsread('./ssdf_data/sin_train_data/2_13_.xlsx');

test_no_1 = xlsread('./ssdf_data/test_data/1_11_.xlsx');
test_no_2 = xlsread('./ssdf_data/test_data/2_13_.xlsx');


[c_row, c_col] = size(test_no_1);
step = 24;
x_start = 1;
x_end = c_col - 1;

disp(['Input a number between ',num2str(1),' and ',num2str(2)]);
tr_ts_set_num = input('Input the number of sets to test GP:');
disp(['You input number is:',num2str(tr_ts_set_num)]);
if tr_ts_set_num == 1
    [x, y] = DataPrep(train_no_1,step,x_start,x_end,c_col);
    [xs,ys] = DataPrep(test_no_1,step,x_start,x_end,c_col);
%     [x, y] = train_test_xy(train_no_1);
%     [xs,ys] = train_test_xy(test_no_1);
else
    [x, y] = DataPrep(train_no_2,step,x_start,x_end,c_col);
    [xs,ys] = DataPrep(test_no_2,step,x_start,x_end,c_col);
%     [x, y] = train_test_xy(train_no_2);
%     [xs,ys] = train_test_xy(test_no_2);
end
Y = [1:length(ys)]';
X = xs; 

%% Train and predict
[pred,se,ci] = GpTrainTest(x,y,xs,ys,X,Y);
res_mat = [ys pred ci se];
xlswrite(strcat(strcat('./ssdf_data/sin_result/sen_no_',num2str(tr_ts_set_num),'/',...
                      num2str(tr_ts_set_num),'res'),'.xlsx'), res_mat, 'Sheet1');

    

function [x,y] = train_test_xy(temp_set)
x = temp_set(:,end-1);
y = temp_set(:,end);
end











