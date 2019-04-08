clear all;
clc

counts_data = xlsread('./training_data/embd_3/total_counts_data.xlsx');
speeds_data = xlsread('./training_data/embd_3/total_speeds_data.xlsx');
counts_data_copy = counts_data;
speeds_data_copy = speeds_data;
[c_row, c_col] = size(counts_data);
%% Parameters related to sensors
SEN_NUM = 3;
sen_index = [1,2,3];   % to be further determined

step = 24;
x_start = 1;
x_end = c_col - 1;
sen_step = 1;
%% For remove sensor data not needed
sen_remv = []; % this is the order rather than the index of the sensors
sen_remain = setdiff(sen_index, sen_remv);
remv_index = zeros(c_row/SEN_NUM,length(sen_remv));
for i = 1:1:length(sen_remv)
    remv_index(:,i) = [sen_remv(1,i):SEN_NUM:c_row]';
end
remv_index = reshape(remv_index,numel(remv_index),1);
remv_index = sort(remv_index);

counts_data(remv_index,:)=[];
speeds_data(remv_index,:)=[];

test_rand_index = randperm(length(sen_remain))
test_index_unit = sen_remain(1,test_rand_index(1));
test_index = [test_index_unit:SEN_NUM:c_row]';
test_x = counts_data(test_index,:);
[test_xs,test_ys] = DataPrep(test_x,step,x_start,x_end,c_col);
%% This is for preparation of the inputs and outputs
[num_row, num_col] = size(counts_data);

x = counts_data(:,x_start:x_end);
y = counts_data(:,c_col);
[x_row, x_col] = size(x);

%x(:,1) = (linspace(1,num_row,num_row))';   % this is the linear time stamp
%x(:,1) = x(:,1);
%x = mapminmax(x,0,1);

new_row = x_row - step;
new_col = step + x_end - x_start + 1;
new_x = zeros(new_row, new_col);
new_y = zeros(new_row, 1);

temp_x = zeros(1,new_col);
for i = 1:1:new_row  
    temp_fetch = (y(i:1:i+step-1,1))';
    temp_x(1,1:step) = temp_fetch;
    temp_x(1,step+1:end) = x(i+step,:);
    temp_y(1,1) = y(i+step,1);
    
    new_x(i,:) = temp_x;
    new_y(i,:) = temp_y; 
end

%% This is for getting the training and testing data sets ready
%disp('Input a number: 1 for joint and 2 for single:');
mode_index = input('Input a number: 1 for joint and 2 for single:');
disp(['You input number is:',num2str(mode_index)]);
switch mode_index
    case 1
        [total_row, total_col] = size(new_x);
        Ntr = ceil(total_row * 0.75);
        Nte = total_row - Ntr;

        x = new_x(1:Ntr,:);
        y = new_y(1:Ntr);
        xs = new_x(Ntr+1:end,:);
        ys = new_y(Ntr+1:end,:);
    case 2
        x = new_x;
        y = new_y;
        xs = test_xs;
        ys = test_ys;
end

 Y = [1:length(ys)]';
 X = xs; 

%% Gaussian model training and prediction
GpTrainTest(x,y,xs,ys,X,Y);

% gprMdl = fitrgp(x,y,'KernelFunction','squaredexponential',...
%       'FitMethod','exact','PredictMethod','exact');
% 
% [pred,se,ci] = predict(gprMdl,X,'Alpha',0.01);
% 
% 
% disp(' ')
% figure(4)
% set(gca, 'FontSize', 24)
% f = [ci(:,1); flipdim(ci(:,2),1)];
% fill([Y; flipdim(Y,1)], f, [7 7 7]/8)
% 
% hold on; plot(Y, pred, 'LineWidth', 2); plot(Y, ys, 'o', 'MarkerSize', 6)
% 
% grid on
% xlabel('input, x')
% ylabel('output, y')
%axis([0.0 10.0 -10.0 20.0])




% %meanfunc = [];                    % empty: don't use a mean function
% %meanfunc = @mean
% meanfunc = @meanConst;                    % empty: don't use a mean function
% covfunc = @covSEiso;              % Squared Exponental covariance function
% likfunc = @likGauss;              % Gaussian likelihood
% %meanfunc = 2.5;
% 
% %hyp = struct('mean', 2.5*[], 'cov', 0.01+[0 0], 'lik', -1*7);
% 
% hyp = struct('mean', [3], 'cov', [0 0], 'lik', -10);
% hyp2 = minimize(hyp, @gp, -1000, @infGaussLik, meanfunc, covfunc, likfunc, x, y);
% 
% % predict and plot
% [mu s2] = gp(hyp2, @infGaussLik, meanfunc, covfunc, likfunc, x, y);











