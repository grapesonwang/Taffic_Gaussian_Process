clear all;
clc

counts_data = xlsread('./training_data/total_counts_data.xlsx');
speeds_data = xlsread('./training_data/total_speeds_data.xlsx');

num_row = 6048;
step = 96;  %6048/21/3
day_num = num_row / step /3;
train_num = ceil(0.75 * day_num);
test_num = day_num - train_num;

x = speeds_data(1:3:num_row,4:9);
y = speeds_data(1:3:num_row,10);
[x_row, x_col] = size(x);
x(:,1) = (linspace(1,num_row/3,num_row/3))';
x(:,1) = x(:,1);

% for training
boundry = train_num * step;
xs = x(boundry+1:end,:);
ys = y(boundry+1:end,:);
Ns = length(ys);

xn = x(1:boundry,:);
yn = y(1:boundry,:);

x = xn;
y = yn;

max_col_vec = max(x);
min_col_vec = min(x);
dif_col_vec = max_col_vec - min_col_vec;

X = zeros(x_row, x_col);

for i = 1:1:x_col
    X(:,i) = linspace(min_col_vec(1,i),max_col_vec(1,i),x_row);
end

%X = linspace(min_col_vec,max_col_vec),n)';
Y = [1:length(ys)]';


meanfunc = [];                    % empty: don't use a mean function
%meanfunc = @meanConst;                    % empty: don't use a mean function
covfunc = @covSEiso;              % Squared Exponental covariance function
likfunc = @likGauss;              % Gaussian likelihood
%meanfunc = 2.5;

%hyp = struct('mean', 2.5*[], 'cov', 0.01+[0 0], 'lik', -1*7);
int_mean = y;
%int_mean = int_mean';
int_cov = cov(x);

hyp = struct('mean', [] , 'cov', [0,0], 'lik', -10);
hyp2 = minimize(hyp, @gp, -1000, @infGaussLik, meanfunc, covfunc, likfunc, x, y);
% hyp2.lik = -5;
% hyp2.cov(1) = 1.274;%0.6;
% hyp2.cov(2) = -0.978*-2;
% disp('finished')

% predict and plot
[mu s2] = gp(hyp2, @infGaussLik, meanfunc, covfunc, likfunc, x, y, xs);

%s2 = mean(s2)*2*ones(Ns,1); % 0.0065;
s2 = mean(s2)*0.5*ones(Ns,1); % 0.0065;
%s2 = s2+0.0065/4
f = [mu+2*sqrt(s2); flipdim(mu-2*sqrt(s2),1)];
%fill([xs/scale; flipdim(xs/scale,1)], f, [7 7 7]/8);
fill([Y; flipdim(Y,1)], f, [7 7 7]/8);
%hold on; plot(xs/scale, mu); plot(x/scale, y, '+')
hold on; plot(Y, mu, 'LineWidth', 2); plot(Y, ys, 'o', 'MarkerSize', 6)
hold off



%axis([0 spann*pi -2 2])
% set(gca, 'fontsize', 15)
% legend('conf band', 'mean f', 'datapoint')
% 
% xlabel('x (mm)'), ylabel('z (mm)')