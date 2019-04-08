clear all;
clc


counts_data = xlsread('./training_data/total_counts_data.xlsx');
speeds_data = xlsread('./training_data/total_speeds_data.xlsx');
counts_data_copy = counts_data;
speeds_data_copy = speeds_data;
[c_row, c_col] = size(counts_data);


step = 24;
x_start = 4;
x_end = c_col - 1;
sen_step = 1;

% counts_data(sen_step+1:sen_step+1:end,:)=[];
% speeds_data(sen_step+1:sen_step+1:end,:)=[];
counts_data = counts_data(1:3:end,:);
speeds_data = speeds_data(1:3:end,:);
[num_row, num_col] = size(counts_data);

x = counts_data(:,x_start:x_end);
y = counts_data(:,c_col);

[x_row, x_col] = size(x);
x(:,1) = (linspace(1,num_row,num_row))';
%x(:,1) = x(:,1);
%x = mapminmax(x,0,1);

new_row = (x_row/sen_step - step) * sen_step;
new_col = step + x_end - x_start + 1;
new_x = zeros(new_row, new_col);
new_y = zeros(new_row, 1);
temp_x = zeros(sen_step,new_col);

% for i = 1:1:(new_row/sen_step)
%     for j = 1:1:sen_step
%         
%     end
% end


for i = 1:sen_step:new_row
    %temp_x = zeros(sen_step,new_col);5
    
    for j = 1:1:sen_step
        
        temp_fetch = (y(i:sen_step:i+(step-1)*sen_step,1))';
        temp_x(j,1:step) = temp_fetch;
        temp_x(j,step+1:end) = x(i+step*sen_step,:);
        temp_y(j,1) = y(i+step*sen_step,1);
    end
    new_x(i:i+0,:) = temp_x;
    new_y(i:i+0,:) = temp_y; 
end

[total_row, total_col] = size(new_x);
Ntr = ceil(total_row * 0.75);
Nte = total_row - Ntr;

x = new_x(1:Ntr,:);
%x = new_x(1:Ntr,1:step);
y = new_y(1:Ntr);
xs = new_x(Ntr+1:end,:);
ys = new_y(Ntr+1:end,:);

% [x_row, x_col] = size(x);
% 
% max_col_vec = max(x);
% min_col_vec = min(x);
% dif_col_vec = max_col_vec - min_col_vec;
% 
% X = zeros(x_row, x_col);
% 
% for i = 1:1:x_col
%     X(:,i) = linspace(min_col_vec(1,i),max_col_vec(1,i),x_row);
% end

%X = linspace(min_col_vec,max_col_vec),n)';
 Y = [1:length(ys)]';

X = xs; 

gprMdl = fitrgp(x,y,'KernelFunction','squaredexponential',...
      'FitMethod','exact','PredictMethod','exact');

[pred,se,ci] = predict(gprMdl,X,'Alpha',0.01);

% ypred = predict(gprMdl);

disp(' ')
figure(3)
set(gca, 'FontSize', 24)
f = [ci(:,1); flipdim(ci(:,2),1)];
fill([Y; flipdim(Y,1)], f, [7 7 7]/8)

hold on; plot(Y, pred, 'LineWidth', 2); plot(Y, ys, 'o', 'MarkerSize', 6)

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











