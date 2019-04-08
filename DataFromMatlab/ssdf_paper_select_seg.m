clear all;
clc
folder_name = '1_2_13_14_21_';
path = strcat('./ssdf_data/train_data/',folder_name,'/');
weight = xlsread('./matlab_with_R/embd_p/asy_mat_2R.xlsx');
sen_id = xlsread(strcat(path,'sen_mat.xlsx'));
[row, col] = size(sen_id);

figure;
K = 10;
for i = 1:1:row
    temp_id = sen_id(i,:);
    temp_weight = weight(temp_id,temp_id);
    output((i-1)*col+1:i*col,:) = temp_weight;
    subplot(5,4,i);
    image(temp_weight * K); 
%     colorbar;
%     set(gca,'ytick',[],'xtick',[]);
%     title('rmse=')
    first_row_vec(i,:) = temp_weight(1,:);
    first_col_vec(i,:) = temp_weight(:,1);
    
    vec = sum(temp_weight,1);
    vec_h = vec(1,1);
    vec = sum(temp_weight,2);
    vec_v = vec(1,1);
    temp_vec = [sum(sum(temp_weight)), vec_h, vec_v];
    vec_w(i,:) = temp_vec;
end

suptitle('sub-matrix T');

figure;
subplot(2,1,1);
image(first_row_vec' * K);
colorbar;
xlabel('candidate set index','Fontname', 'Times New Roman','FontSize',12);
ylabel('distance','Fontname', 'Times New Roman','FontSize',12);
subplot(2,1,2);
image(first_col_vec' * K);
colorbar;
xlabel('candidate set index','Fontname', 'Times New Roman','FontSize',12);
ylabel('distance','Fontname', 'Times New Roman','FontSize',12);
% xlabel('sub-matrix of T','Fontname', 'Times New Roman','FontSize',12);
% ylabel('segment index','Fontname', 'Times New Roman','FontSize',12);

 
 %% RMSE
path_str = strcat('./ssdf_data/train_data/',folder_name,'/')
name_mat = xlsread(strcat(path_str,'name_mat.xlsx'));
[nam_row, nam_col] = size(name_mat);

path_result = strcat('./ssdf_data/sub_result/',folder_name,'/')
for i = 1:1:nam_row
    temp_name_vec = name_mat(i,:);
    temp_name = vec2str_sim(temp_name_vec)
    temp_set = xlsread(strcat(path_result,temp_name,'res','.xlsx'));
    [t_row, t_col] = size(temp_set);
    true = temp_set(:,1);
    pred = temp_set(:,2);
%     true = AverageZero(true);
%     pred = AverageZero(pred);
    rmse(i,1) = RMSE(true,pred);
    mape(i,1) = MAPE(true,pred);
end
vec_w(:,4) = rmse;
vec_w(:,5) = mape;

savepath = ['./ssdf_data/ssdf_paper/' folder_name '/'] ;
%copyfile(path,savepath);
if ~exist(savepath)
   mkdir(savepath);
else
    rmdir(savepath,'s');
    mkdir(savepath);
end
 xlswrite(strcat(savepath,folder_name,'.xlsx'), output, 'Sheet1');
 xlswrite(strcat(savepath,folder_name,'weight','.xlsx'), vec_w, 'Sheet1');
 saveas(gcf,strcat(savepath,folder_name));

function rmse = RMSE(true,pred)
err = abs(true - pred);
err_sum = err'* err;
err_avr = err_sum/length(true);
err_std = sqrt(err_avr);

rmse = err_std;
end

function mape = MAPE(true,pred)
err = abs(true - pred);
err_per = err./(true+0.1);
if max(err_per) == Inf
    disp('error.....');
end
err_avr = sum(err_per)/length(true);
mape = err_avr;
end

function  vec = AverageZero(vec)
for i = 1:1:length(vec)
    if vec(i) == 0
        vec(i) = vec(i-1) + vec(i+1);
    end
end
end