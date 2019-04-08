function [train_data, test_data] = ...
    TrainTestData(total_data,day_num,boundry,TIME_SLOT,SEN_NUM)
%UNTITLED12 此处显示有关此函数的摘要
%   此处显示详细说明
test_boundry = 7;
train_end =  SEN_NUM * TIME_SLOT * boundry;
train_data = total_data(1:train_end,:);
test_start = (day_num - test_boundry) * SEN_NUM * TIME_SLOT;
test_data = total_data(test_start+1:end,:);
%test_data = total_data(train_end+1:end,:);
end

