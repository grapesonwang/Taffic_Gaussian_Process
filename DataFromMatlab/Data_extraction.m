function plot_mat = Data_extraction(cell_data, sen_id)
%UNTITLED18 此处显示有关此函数的摘要
%   此处显示详细说明
[c_row, c_col] = size(cell_data);

[m_row, m_col] = size(cell_data{1,1});

[s_row, s_col] = size(sen_id);

dim_vec = c_row * m_row;
% x_coor = [1:dim_vec]; This should be the time

plot_mat = zeros(s_row,dim_vec);

for i = 1:1:s_row
    for j = 1:1:c_row
        sin_cell = cell_data(j,1);
        sin_mat = sin_cell{1,1};
        plot_mat(i,(m_row*(j-1)+1):m_row*j) = sin_mat(:,sen_id(i,1))';
    end
end

plot_mat = plot_mat';

end

