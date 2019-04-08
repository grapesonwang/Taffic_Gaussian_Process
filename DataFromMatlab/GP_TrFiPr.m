clear all;
clc


counts_data = xlsread('./training_data/embd_3/total_counts_data.xlsx');
speeds_data = xlsread('./training_data/embd_3/total_speeds_data.xlsx');
%% Expanding x with year
[c_row, c_col] = size(counts_data);


x_year = ones(c_row,1) * 2016;
% x_year = (linspace(1,c_row,c_row))';
counts_data = [x_year counts_data];
speeds_data = [x_year speeds_data];
[c_row, c_col] = size(counts_data);


x_start = 1;
%% Strategy one
x_end = c_col - 1; 
%% Strategy two
%x_end = 5; 

xs_index = [1:3:c_row]';
xs = counts_data(xs_index,x_start:x_end);
ys = counts_data(xs_index,end);
%num_row = 4032;
sen_step = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Just for testing 1 2 to train and 3 to test
% counts_copy = counts_data;
% remv_index = [3:3:c_row]';
% counts_copy(remv_index,:) = [];
% counts_data = counts_copy;
% [c_row, c_col] = size(counts_data);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


x = counts_data(1:sen_step:c_row,x_start:x_end);
y = counts_data(1:sen_step:c_row,end);
[x_row, x_col] = size(x);
%x(:,1) = (linspace(1,num_row/sen_step,num_row/sen_step))';
%x(:,1) = x(:,1);
%x = mapminmax(x,0,1);





% max_col_vec = max(x);
% min_col_vec = min(x);
% dif_col_vec = max_col_vec - min_col_vec;
% 
% X = zeros(x_row, x_col);
% 
% for i = 1:1:x_col
%     X(:,i) = linspace(min_col_vec(1,i),max_col_vec(1,i),x_row);
% end

X = xs;
Y = [1:length(ys)]';

gprMdl = fitrgp(x,y,'KernelFunction','squaredexponential',...
      'FitMethod','exact','PredictMethod','exact');

[pred,se,ci] = predict(gprMdl,X,'Alpha',0.01);

% ypred = predict(gprMdl);

disp(' ')
figure(5)
set(gca, 'FontSize', 24)
f = [ci(:,1); flipdim(ci(:,2),1)];
fill([Y; flipdim(Y,1)], f, [7 7 7]/8)

hold on; plot(Y, pred, 'LineWidth', 2); plot(Y, ys, '-o', 'MarkerSize', 6)

grid on
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











