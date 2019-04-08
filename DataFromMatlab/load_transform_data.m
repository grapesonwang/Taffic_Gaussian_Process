clear all
clc
%% data loading from GIS shapefiles//potentially there are some errors here
% First characters are all capital so it is compatible with raw GIS data
% Nodes=shaperead('C:\Users\uos\Documents\Peng WANG\Geoff_Boeing\Alonso_data\Gis\Gis\nodes.shp')
% SectionsGeo=shaperead('C:\Users\uos\Documents\Peng WANG\Geoff_Boeing\Alonso_data\Gis\Gis\sectionsGeo.shp')
% Sections=shaperead('C:\Users\uos\Documents\Peng WANG\Geoff_Boeing\Alonso_data\Gis\Gis\sections.shp')
% Public_transport_lines = shaperead('C:\Users\uos\Documents\Peng WANG\Geoff_Boeing\Alonso_data\Gis\Gis\public_transport_lines.shp')
% Polygons = shaperead('C:\Users\uos\Documents\Peng WANG\Geoff_Boeing\Alonso_data\Gis\Gis\polygons.shp')
% Meterings = shaperead('C:\Users\uos\Documents\Peng WANG\Geoff_Boeing\Alonso_data\Gis\Gis\meterings.shp')
% Detectors_original = shaperead('C:\Users\uos\Documents\Peng WANG\Geoff_Boeing\Alonso_data\Gis\Gis\detectors.shp')
% Centroids = shaperead('C:\Users\uos\Documents\Peng WANG\Geoff_Boeing\Alonso_data\Gis\Gis\centroids.shp')
% Centroids_area = shaperead('C:\Users\uos\Documents\Peng WANG\Geoff_Boeing\Alonso_data\Gis\Gis\centroids_area.shp')
% Centroids_connections = shaperead('C:\Users\uos\Documents\Peng WANG\Geoff_Boeing\Alonso_data\Gis\Gis\centroid_connections.shp')
% Bus_stops = shaperead('C:\Users\uos\Documents\Peng WANG\Geoff_Boeing\Alonso_data\Gis\Gis\bus_stops.shp')
%% data loading from Matthew's work
load('2016speedandcounts_correct.mat');
load('SANTANDER_NETWORK_INFO_AIMSUN.mat');
san_graph = xlsread('san_data_to_matlab.xlsx','A2:Q4107');
%% data processing test
[sec_row,sec_col] = size(Sections);
% extract the from and to node of sections
f_node = extractfield(Sections,'fnode');
t_node = extractfield(Sections,'tnode');

% find out how many sections are of the same from and to nodes (normally related to roundabouts)
eq_index = find(f_node==t_node);
eq_node = f_node(1,eq_index);
[node index] = sort(eq_node);  % sort eq_node
eq_node_unique = unique(eq_node,'stable');

%% data processing
Sec_id = extractfield(Sections,'id');
Node_id = extractfield(Nodes,'id');
adj_Sec = FindSecAdj(Sec_id,Node_id,f_node,t_node);

for i=1:1:sec_row
    row_sum(i,1) = sum(adj_Sec(i,:));
end
row_sum = row_sum';

counter = 0;
for j=1:1:length(eq_node_unique)
    counter = counter + length(find(f_node==eq_node_unique(1,j)));
    counter = counter + length(find(t_node==eq_node_unique(1,j)));
end

f_seq = [];
t_seq = [];
for j=1:1:length(eq_node_unique)
    f_sub_seq = find(f_node == eq_node_unique(1,j));
    f_seq = [f_seq f_sub_seq];
    
    t_sub_seq = find(t_node == eq_node_unique(1,j));
    t_seq = [t_seq t_sub_seq];
end

f_plus_t_seq = [f_seq t_seq];
[seq_value seq_index] = sort(f_plus_t_seq); 
seq_unique = unique(seq_value,'stable');

% del_seq = [];
% for i=1:1:length(seq_unique)
%     if f_node(1,seq_unique(i)) == t_node(1,seq_unique(i))
%         del_seq = [del_seq i];
%     end
% end
% seq_unique(:,del_seq) = [];

% f_diff_t_check = [seq_unique; Sec_id(1,seq_unique); f_node(1,seq_unique);...
%     t_node(1,seq_unique); row_sum(1,seq_unique)]';

temp_seq = [1:1:sec_row];
temp_id = Sec_id;
temp_id(:,[[1:1:815] seq_unique]) = [];
temp_seq(:,[[1:1:815] seq_unique]) = [];
sec_left = temp_id;
seq_left = temp_seq;


% left_check = [temp_seq; sec_left; Sec_id(1,seq_left); f_node(1,seq_left);...
%     t_node(1,seq_left); row_sum(1,seq_left)]';

% left_check = [temp_seq; Sec_id(1,seq_left); f_node(1,seq_left);...
%     t_node(1,seq_left); row_sum(1,seq_left)]';

ex_adj_Sec = adj_Sec - eye(sec_row, sec_row);
for i=1:1:sec_row
    ex_row_sum(i,1) = sum(ex_adj_Sec(i,:));   % col vector
    ex_col_sum(1,i) = sum(ex_adj_Sec(:,i));   % row vector
end

ex_row_dim = max(ex_row_sum);
ex_col_dim = max(ex_col_sum);

diff_t_node = [];
diff_f_node = [];
for i = 1:1:length(seq_unique)
    t_cur_seq = find(ex_adj_Sec(seq_unique(1,i),:) == 1);
    f_cur_seq = find(ex_adj_Sec(:,seq_unique(1,i)) == 1);
    
    row_zero = zeros(1,ex_row_dim);
    col_zero = zeros(1,ex_col_dim);
    
    row_zero(1,1:length(t_cur_seq)) = Sec_id(1,t_cur_seq);
    col_zero(1,1:length(f_cur_seq)) = Sec_id(1,f_cur_seq);
    
    diff_t_node = [diff_t_node; row_zero];
    diff_f_node = [diff_f_node; col_zero];
end

left_t_node = [];
left_f_node = [];
for i = 1:1:length(seq_left)
    t_cur_seq = find(ex_adj_Sec(seq_left(1,i),:) == 1);
    f_cur_seq = find(ex_adj_Sec(:,seq_left(1,i)) == 1);
    
    row_zero = zeros(1,ex_row_dim);
    col_zero = zeros(1,ex_col_dim);
    
    row_zero(1,1:length(t_cur_seq)) = Sec_id(1,t_cur_seq);
    col_zero(1,1:length(f_cur_seq)) = Sec_id(1,f_cur_seq);
    
    left_t_node = [left_t_node; row_zero];
    left_f_node = [left_f_node; col_zero];
end

f_diff_t_check = [seq_unique; f_node(1,seq_unique); t_node(1,seq_unique); ...
     diff_f_node'; Sec_id(1,seq_unique); diff_t_node'; row_sum(1,seq_unique)]';
left_check = [seq_left; f_node(1,seq_left); t_node(1,seq_left); ...
     left_f_node'; Sec_id(1,seq_left); left_t_node'; row_sum(1,seq_left)]';

sub_row_sum = row_sum(1,seq_unique);
manual_sec_id = Sec_id(1,index);
%adj_corrected = ManuallyCorrectAdj(adj_Sec,node,index)
