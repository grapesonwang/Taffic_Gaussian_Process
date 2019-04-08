clear all;
clc
TIME_SLOT = 96;
% load('2016speedandcounts_correct.mat');
% load('SANTANDER_NETWORK_INFO_AIMSUN.mat');
%% This is for data loading
% % =========================================================================
% Initialization
% =========================================================================
% --- Load network --------------------------------------------------------
load('SANTANDER_NETWORK_INFO_AIMSUN')
% --- ID corrections ------------------------------------------------------
Detectors(90).id = 49518; Detectors(264).eid = '3092'; Detectors(265).eid = '3087';
% --- Load data (the years worth of open data from Santander loop sensors)-
% load('correctedData-test')
load('2016speedandcounts_correct')
% --- Load IDs (common names and orders across all files) for these senors 
load('SecandSenIDs')
copy_SenIDs = SenIDs;
[temp_SenIDs,temp_SenIDs_index] = SenIdConvt(SenIDs,copy_SenIDs);
if isempty(temp_SenIDs_index)
    SenIDs = temp_SenIDs;
else
    SenIDs(:,temp_SenIDs_index) = [];
end

san_graph = xlsread('san_data_to_matlab.xlsx','A2:Q4107');
seg_typ_conv = xlsread('seg_type_convert.xlsx','A1:E14');

%% This is for generate weight matrix
[row, col] = size(Sections); %4106*1 struct
len_vec = [];
for i =1:1:row
    cood_vec = [Sections(i).X; Sections(i).Y];
    seg_len = SegLength(cood_vec);
    len_vec = [len_vec;seg_len];
end

seg_id = extractfield(Sections,'id')';
seg_len = len_vec;
seg_lan = extractfield(Sections,'nb_lanes')';
seg_spd = extractfield(Sections,'speed')';
seg_cap = extractfield(Sections,'capacity')';
seg_typ = extractfield(Sections,'rd_type')';

[typ_row, typ_col] = size(seg_typ_conv);
for i = 1:1:typ_row
    temp_index = find(seg_typ == seg_typ_conv(i,1));
    seg_typ(temp_index,1) = seg_typ_conv(i,3);
end

seg_len = seg_len ./ max(seg_len);
seg_lan = seg_lan ./ max(seg_lan);
seg_spd = seg_spd ./ max(seg_spd);
seg_cap = seg_cap ./ max(seg_cap);
seg_typ = 1 ./ seg_typ;

org_adj_matrix = cal_adj_matrix(san_graph);
new_adj_matrix = eye(row, row);
for i = 1:1:row
    temp_index = find(org_adj_matrix(i,:) == 1);
    for j = 1:1:length(temp_index)
        temp_weight = [abs(seg_len(i,1) - seg_len(temp_index(j),1)), ...
                       abs(seg_lan(i,1) - seg_lan(temp_index(j),1)), ...
                       abs(seg_spd(i,1) - seg_spd(temp_index(j),1)), ...
                       abs(seg_typ(i,1) - seg_typ(temp_index(j),1))];
        temp_weight = sum(temp_weight);
        new_adj_matrix(i,temp_index(j)) = temp_weight;
    end 
end

sp_org_adj_matrix = sparse(org_adj_matrix);
org_weight_matrix = graphallshortestpaths(sp_org_adj_matrix);

sp_new_adj_matrix = sparse(new_adj_matrix);
new_weight_matrix = graphallshortestpaths(sp_new_adj_matrix);

%% This is kind of for drawing an image, it is not strongly related with our work 
img_weight_matrix = new_weight_matrix;
Inf_index = find(img_weight_matrix == Inf);
img_weight_matrix(Inf_index) = 0;
max_val = max(max(img_weight_matrix));
min_val = min(min(img_weight_matrix));
img_weight_matrix = img_weight_matrix / (max_val - min_val);
img_weight_matrix = img_weight_matrix * 255;
diag_val = eye(row) * (max_val - min_val)*255/2.0;
img_weight_matrix = img_weight_matrix + diag_val;
% figure(1000);
% image(img_weight_matrix);
% colorbar;

sym_img_weight_matrix = (img_weight_matrix + img_weight_matrix')./2.0;
% figure(1001);
% image(sym_img_weight_matrix);
% colorbar;

dim = 3;
neg_diag = -sym_img_weight_matrix(1,1) * eye(row,row);
sym_img_weight_matrix = sym_img_weight_matrix + neg_diag;
[mds_weight_matrix,stress] = cmdscale(sym_img_weight_matrix,dim);
% figure(1002);
% scatter3(mds_weight_matrix(:,1),mds_weight_matrix(:,2),...
%          mds_weight_matrix(:,3),20);  

%% This is for exporting all potentially useful data
seg_att = struct();
for i =1:1:row
    seg_att(i).seg_id = seg_id(i,1);
    seg_att(i).seg_len = seg_len(i,1);
    seg_att(i).seg_lan = seg_lan(i,1);
    seg_att(i).seg_spd = seg_spd(i,1);
    seg_att(i).seg_cap = seg_cap(i,1);
    seg_att(i).seg_typ = seg_typ(i,1);
end
seg_att = seg_att';

%% This is for data pre-processing

sec_id = extractfield(Detectors,'section_id');
sen_id = extractfield(Detectors,'id');
sen_eid = extractfield(Detectors,'eid');
sen_eid = cellfun(@str2num,sen_eid);

temp_mat = [sec_id; sen_id; sen_eid];
[ b, pos ] = sort( temp_mat( 1, : ) );  % Sort them by the sectionID
temp_mat = temp_mat( :, pos );          % The reason is that the weight matrix
sec_id = temp_mat(1,:);                 % is built according to sectionID
sen_id = temp_mat(2,:);
sen_eid = temp_mat(3,:);

[sec_id, sen_id, sen_eid, seg_id] = DelInf(sec_id, sen_id, sen_eid, seg_id, new_weight_matrix);
[temp_sen_eid,temp_sensor_index] = SenIdConvt(sen_eid,copy_SenIDs);
% Convert the 'eid' of sensors into 'id' of sensors
% Basically we use the 'id' of sensors

% From here, we have already transferred the 'eid' to 'id' (both for sensors)
% But the process in the following, 'sen_eid' are actually 'id'
if ~isempty(temp_sensor_index)
    sen_eid = temp_sen_eid;
    sec_id(:,temp_sensor_index) = [];
    sen_id(:,temp_sensor_index) = [];
    sen_eid(:,temp_sensor_index) = [];
end

% There are more than one sensor on some segments, we only consider one on 
% each segment
[B, I] = unique(sec_id, 'first');
diff_index = setdiff(1:numel(sec_id),I);
sec_id(:,diff_index) = [];
sen_id(:,diff_index) = [];
sen_eid(:,diff_index) = [];

%% This is some abnormal sensor with input 0, delete it.
ABNORMAL_ID = 32314;
ABNORMAL_POS = find(sen_eid == ABNORMAL_ID);
sec_id(:,ABNORMAL_POS) = [];
sen_id(:,ABNORMAL_POS) = [];
sen_eid(:,ABNORMAL_POS) = [];

epc_dim = length(sec_id);  % to be manually dicided.
[epc_weight_matrix, sub_sec_index] = CovMatrixCom(seg_id,sec_id,sen_id,epc_dim,new_weight_matrix);

% DataExtraction tries to find out sensor ID in sen_eid are in which colum
% of SavedData_counts, sec_id is not used in this function.
Data_counts_252 = DataExtraction(SenIDs, sen_eid, sec_id, SavedData_counts);
Data_speeds_252 = DataExtraction(SenIDs, sen_eid, sec_id, SavedData_Speeds);

%% For extracting the GIS coordinates of sensors
Sen_XY = SenXYExtraction(Detectors, sen_eid);
% savepath = ['./Sensor_Location/' ] ;
% if ~exist(savepath)
%    mkdir(savepath);
% else
%     rmdir(savepath,'s');
%     mkdir(savepath);
% end
xlswrite(strcat(savepath, 'Sen_XY.xlsx'), Sen_XY, 'Sheet1');

Cluster_cell = LableXYExtraction(sen_eid, Sen_XY);
% sen_lab_XY = [sen_eid; Sen_XY]; % row vector
% cluster_lable = xlsread('./Sensor_Location/cluster_lable.xlsx');
% center_idxs = xlsread('./Sensor_Location/center_idxs.xlsx');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% For training data and testing data extraction
%%% For June of 2016, the first day was Wednesday, so we start from row 6 ,
%%% which was Monday and end with row 26, which was Sunday. That is totally
%%% 3 weeks.
reg_month_num = 6;  % Currently we only use data of the sixth month
day_start = 6;
day_end = 26;
reg_sen_num = 1;
Data_counts_3w = Data_counts_252(day_start:day_end, reg_month_num);
Data_speeds_3w = Data_speeds_252(day_start:day_end, reg_month_num);

%% This is for finding the regularity of the data
% RegPlotData(Data_counts_3w, reg_sen_num);
% RegPlotData(Data_speeds_3w, reg_sen_num);
%% This is for augumented data regularity finding
%Augmt_RegPlotData(Data_counts_3w, Cluster_cell);
augment_index = [1  3  4  6  7  8  9  ...
                 10 11 13 14 15 17 18 ...
                 19 20 21 22 24 25 26];
Cluster_mat = Cluster_cell{1,1};
expect_index = (Cluster_mat(1,augment_index))';
SEN_NUM = length(expect_index);
SEQ_ID_TABLE = [[1:1:SEN_NUM]',expect_index]';
%% This is for extracting a special set of data
%expect_index = [1,2,3,4,5,9,10,11,13,16,17,18,21,22,23,24,26,28,29,30]';
expect_counts_matrix = Data_extraction(Data_counts_3w, expect_index);
expect_speeds_matrix = Data_extraction(Data_speeds_3w, expect_index);
xlswrite('./training_data/embd_p/expect_counts_matrix.xlsx', expect_counts_matrix, 'Sheet1');
xlswrite('./training_data/embd_p/expect_speeds_matrix.xlsx', expect_speeds_matrix, 'Sheet1');
%% This part is for Plot and Data filling
month_num = 6;
max_sen = 252; % number of sensor data we want to use
day_num = 21; % That is for 3 weeks as there are missing data in the last days
% PlotData(Data_counts_252,day_num,month_num,max_sen);
% PlotData(Data_speeds_252,day_num,month_num,max_seg);

% DataFilling(Data_counts_252);
% DataFilling(Data_speeds_252);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% This is for data exporting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% just in case we need to export the data to be processed by R
%%%%%
% new_weight_matrix(find(new_weight_matrix==Inf)) = 0.005;
% test_weight_matrix = new_weight_matrix(1:300,1:300);
xlswrite('./matlab_with_R/embd_p/asy_mat_2R.xlsx', epc_weight_matrix, 'Sheet1')
%%%%%



%% This is for computing the Embedded coordinates
gspace = xlsread('./matlab_with_R/embd_p/gspace.xlsx');
weight = xlsread('./matlab_with_R/embd_p/weight.xlsx');
embd = gspace .* weight;
embd_euclidean = embd;
expect_embed = embd_euclidean(expect_index,:);
xlswrite('./matlab_with_R/embd_p/embd_euclidean.xlsx', embd_euclidean, 'Sheet1')
xlswrite('./matlab_with_R/embd_p/expect_embed.xlsx', expect_embed, 'Sheet1')


%% This is for data preparation
% un-comment them after getting the better sensors
% clear all;
% clc

DateGenerate();
embd_loc = xlsread('./matlab_with_R/embd_p/expect_embed.xlsx');
selected_date = xlsread('./training_data/embd_p/selected_date_vec.xlsx');
real_speeds = xlsread('./training_data/embd_p/expect_speeds_matrix.xlsx');
real_counts = xlsread('./training_data/embd_p/expect_counts_matrix.xlsx');
[total_counts_data,total_speeds_data] = ...
    RoughDataPrep(embd_loc,selected_date,real_speeds,real_counts,expect_index);

boundry = 14;
test_boundry = 7;
[train_counts_data, test_counts_data] = ...
    TrainTestData(total_counts_data,day_num,boundry,TIME_SLOT,SEN_NUM);
[train_speeds_data, test_speeds_data] = ...
    TrainTestData(total_counts_data,day_num,boundry,TIME_SLOT,SEN_NUM);
xlswrite('./training_data/embd_p/train_counts_data.xlsx', train_counts_data, 'Sheet1');
xlswrite('./training_data/embd_p/test_counts_data.xlsx', test_counts_data, 'Sheet1');
xlswrite('./training_data/embd_p/train_speeds_data.xlsx', train_speeds_data, 'Sheet1');
xlswrite('./training_data/embd_p/test_speeds_data.xlsx', test_speeds_data, 'Sheet1');
%% For preparation of interval analysis
common_index = [5,6];
diff_index_num = 1;  %which means that the train set contains length(common_index) + diff_index_num sensors
extra_test_index = [7,8]
%% For ensuring there are enough subsets
remain_index = setdiff(SEQ_ID_TABLE(1,:),common_index);
k_subset = nchoosek(remain_index,diff_index_num);
disp('Input the number of training sets you want to randomly select:');
disp(['The number should between'  num2str(1)  ' and  '  num2str(size(k_subset,1))]);
sub_train_num =  input('Input the number:');
disp(['You input number is:',num2str(sub_train_num)]);
% sub_train_num = 20;
% Time series reconstruction training data preparation
folder_train_data = SubTrainDataEnhanced(train_counts_data,SEQ_ID_TABLE,sub_train_num,...
             common_index,diff_index_num,boundry,TIME_SLOT,SEN_NUM);
% Only time series and location training data preparation
SingleTrainData(train_counts_data,SEQ_ID_TABLE,common_index,boundry,TIME_SLOT,SEN_NUM);

% They share the common testing data
SubTestDataEnhanced(folder_train_data, test_counts_data,SEQ_ID_TABLE,[common_index,extra_test_index],test_boundry,TIME_SLOT,SEN_NUM);
xlswrite('./training_data/embd_p/total_counts_data.xlsx', total_counts_data, 'Sheet1');
xlswrite('./training_data/embd_p/total_speeds_data.xlsx', total_speeds_data, 'Sheet1');

%% This part is to train the Gaussian Processes models

disp(['Gonna train the Gaussian Processes models? ']);
DECISION = input('Input 1 to train and 0 to quit:');
disp(['You decision is:',DECISION]);
if DECISION == 0
    disp(['Have a nice day!']);
else
    SubGPEnhanced(folder_train_data,[common_index,extra_test_index],SEQ_ID_TABLE);
end


%%
function [total_counts_data,total_speeds_data] = ...
    RoughDataPrep(embd_loc,selected_date,real_speeds,real_counts,expect_index)
[EMB_ROW, EMB_COL] = size(embd_loc);
[DAT_ROW, DAT_COL] = size(selected_date);
SEN_NUM = length(expect_index);
%SEN_VEC = expect_index();

total_counts_data = zeros(SEN_NUM*DAT_ROW,(DAT_COL+EMB_COL+1)); % 1 is for output
total_speeds_data = zeros(SEN_NUM*DAT_ROW,(DAT_COL+EMB_COL+1));
for i = 1:1:DAT_ROW
    ROW_START = (i-1)*SEN_NUM+1;
    ROW_END = i*SEN_NUM;
    total_counts_data(ROW_START:ROW_END,1:DAT_COL) = repmat(selected_date(i,:),SEN_NUM,1);
    total_counts_data(ROW_START:ROW_END,DAT_COL+1:DAT_COL+EMB_COL) = embd_loc(1:SEN_NUM,:);
    total_counts_data(ROW_START:ROW_END,DAT_COL+EMB_COL+1:end) = (real_counts(i,1:SEN_NUM))';
    
    total_speeds_data(ROW_START:ROW_END,1:DAT_COL) = repmat(selected_date(i,:),SEN_NUM,1);
    total_speeds_data(ROW_START:ROW_END,DAT_COL+1:DAT_COL+EMB_COL) = embd_loc(1:SEN_NUM,:);
    total_speeds_data(ROW_START:ROW_END,DAT_COL+EMB_COL+1:end) = (real_speeds(i,1:SEN_NUM))';
end
end


