function [] = Augmt_RegPlotData(cell_data, cluster_cell)
%UNTITLED17 此处显示有关此函数的摘要
%   此处显示详细说明

color_mat = PlotColor();

[cls_row, cls_col] = size(cluster_cell);

for idx_r = 1:1:cls_row
    for idx_c = 1:1:cls_col
        cluster_mat = cluster_cell{idx_r,idx_c};
        plot_index = cluster_mat(1,:);
        sen_num = length(plot_index);
        purePlot(cell_data,plot_index,sen_num,color_mat); 
        fprintf('The %dth test will be finished.\n',idx_c);
        pause(1)
        close all;
    end
    
end
end

function [] = purePlot(cell_data,plot_index,sen_num,color_mat)
[c_row, c_col] = size(cell_data);
[m_row, m_col] = size(cell_data{1,1});
[co_row, co_col] = size(color_mat);
dim_vec = c_row * m_row;
x_coor = [1:dim_vec];
plot_mat = zeros(sen_num,dim_vec);

for i = 1:1:sen_num
    for j = 1:1:c_row
        sin_cell = cell_data(j,1);
        sin_mat = sin_cell{1,1};
        plot_mat(i,(m_row*(j-1)+1):m_row*j) = sin_mat(:,plot_index(1,i))';
    end
end

for j=1:1:sen_num
    color_index = mod(j,co_row);
    if color_index == 0
        color_index = color_index + 1;
    end
    figure(j);
    plot(x_coor,plot_mat(j,:),'-mo',...
        'Color',color_mat(color_index,:),...
        'MarkerSize',3); 
    axis([0 dim_vec 0 max(plot_mat(j,:))]);
    hold on
    pause(2.0);
end

end
