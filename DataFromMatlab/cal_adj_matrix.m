function re_adj_matrix = cal_adj_matrix( san_graph )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明

%san_graph = xlsread('san_data_to_matlab.xlsx','A2:Q4107');
[row,col] = size(san_graph);
adj_matrix = eye(row, row);

sec_id = san_graph(:,4);
edge_in = san_graph(:,5:1:11);
edge_out = san_graph(:,12:1:17);

for i = 1:1:row
    temp_edge_in = edge_in(i,:);
    temp_edge_out = edge_out(i,:);
    temp_in_index = find(temp_edge_in ~= 0);
    temp_out_index = find(temp_edge_out ~= 0);
    
    for h = 1:1:length(temp_out_index)
        temp_entry = temp_edge_out(1,temp_out_index(1,h));
        t_index = find(sec_id == temp_entry);
        adj_matrix(i,t_index) = 1;
    end
    
    for k = 1:1:length(temp_in_index)
        temp_entry = temp_edge_in(1,temp_in_index(1,k));
        f_index = find(sec_id == temp_entry);
        adj_matrix(f_index,i) = 1;
    end    
end

re_adj_matrix = adj_matrix;
end

