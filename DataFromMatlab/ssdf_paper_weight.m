
% TIME_SLOT = 96;
% % load('2016speedandcounts_correct.mat');
% % load('SANTANDER_NETWORK_INFO_AIMSUN.mat');
% %% This is for data loading
% % % =========================================================================
% % Initialization
% % =========================================================================
% % --- Load network --------------------------------------------------------
% load('SANTANDER_NETWORK_INFO_AIMSUN')
% % --- ID corrections ------------------------------------------------------
% Detectors(90).id = 49518; Detectors(264).eid = '3092'; Detectors(265).eid = '3087';
% % --- Load data (the years worth of open data from Santander loop sensors)-
% % load('correctedData-test')
% load('2016speedandcounts_correct')
% % --- Load IDs (common names and orders across all files) for these senors 
% load('SecandSenIDs')
% copy_SenIDs = SenIDs;
% [temp_SenIDs,temp_SenIDs_index] = SenIdConvt(SenIDs,copy_SenIDs);
% if isempty(temp_SenIDs_index)
%     SenIDs = temp_SenIDs;
% else
%     SenIDs(:,temp_SenIDs_index) = [];
% end

san_graph = xlsread('san_data_to_matlab.xlsx','A2:Q4107');
% seg_typ_conv = xlsread('seg_type_convert.xlsx','A1:E14');
% 
% %% This is for generate weight matrix
% [row, col] = size(Sections); %4106*1 struct
% len_vec = [];
% for i =1:1:row
%     cood_vec = [Sections(i).X; Sections(i).Y];
%     seg_len = SegLength(cood_vec);
%     len_vec = [len_vec;seg_len];
% end
% 
% seg_id = extractfield(Sections,'id')';
% seg_len = len_vec;
% seg_lan = extractfield(Sections,'nb_lanes')';
% seg_spd = extractfield(Sections,'speed')';
% seg_cap = extractfield(Sections,'capacity')';
% seg_typ = extractfield(Sections,'rd_type')';
% 
% [typ_row, typ_col] = size(seg_typ_conv);
% for i = 1:1:typ_row
%     temp_index = find(seg_typ == seg_typ_conv(i,1));
%     seg_typ(temp_index,1) = seg_typ_conv(i,3);
% end
% 
% seg_len = seg_len ./ max(seg_len);
% seg_lan = seg_lan ./ max(seg_lan);
% seg_spd = seg_spd ./ max(seg_spd);
% seg_cap = seg_cap ./ max(seg_cap);
% seg_typ = 1 ./ seg_typ;
% 
% org_adj_matrix = cal_adj_matrix(san_graph);
% new_adj_matrix = eye(row, row);
% for i = 1:1:row
%     temp_index = find(org_adj_matrix(i,:) == 1);
%     for j = 1:1:length(temp_index)
%         temp_weight = [abs(seg_len(i,1) - seg_len(temp_index(j),1)), ...
%                        abs(seg_lan(i,1) - seg_lan(temp_index(j),1)), ...
%                        abs(seg_spd(i,1) - seg_spd(temp_index(j),1)), ...
%                        abs(seg_typ(i,1) - seg_typ(temp_index(j),1))];
%         temp_weight = sum(temp_weight);
%         new_adj_matrix(i,temp_index(j)) = temp_weight;
%     end 
% end
% 
% sp_org_adj_matrix = sparse(org_adj_matrix);
% org_weight_matrix = graphallshortestpaths(sp_org_adj_matrix);
% 
% sp_new_adj_matrix = sparse(new_adj_matrix);
% new_weight_matrix = graphallshortestpaths(sp_new_adj_matrix);
K = 10;
gspace = xlsread('./matlab_with_R/embd_p/gspace.xlsx');
weight = xlsread('./matlab_with_R/embd_p/weight.xlsx');
embd = gspace .* weight;
embd_dis_matrix = dist(embd');
figure;
image(embd_dis_matrix*K);
colorbar;
xlabel('segment index','Fontname', 'Times New Roman','FontSize',12);
ylabel('segment index','Fontname', 'Times New Roman','FontSize',12);

org_dis_matrix = xlsread('./matlab_with_R/embd_p/asy_mat_2R.xlsx');
figure;
image(org_dis_matrix*K);
colorbar;
xlabel('segment index','Fontname', 'Times New Roman','FontSize',12);
ylabel('segment index','Fontname', 'Times New Roman','FontSize',12);
% [row, col] = size(org_adj_matrix);
% figure;
% [X, Y] = meshgrid(1:row, 1:row);  
% meshz(X, Y, org_adj_matrix);
% xlabel('segment index','Fontname', 'Times New Roman','FontSize',12);
% ylabel('segment index','Fontname', 'Times New Roman','FontSize',12);
% zlabel('dissimilarity','Fontname', 'Times New Roman','FontSize',12);

%title('Adjacency Matrix');