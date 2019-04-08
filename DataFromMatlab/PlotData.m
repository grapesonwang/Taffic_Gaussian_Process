function [ ] = PlotData(cell_data,day_num,month_num, max_seg)
%UNTITLED13 此处显示有关此函数的摘要
%   此处显示详细说明
temp_cell_data = cell_data(1:day_num,:);
[row,col] = size(temp_cell_data{1,1});
color_mat = PlotColor();
[c_row,c_col] = size(color_mat);
x_coor = [1:1:row]';
for i = 1:1:max_seg
    plot_mat = zeros(row, day_num);

    for h = 1:1:day_num
        sin_cell = temp_cell_data(h,month_num);
        sin_mat = sin_cell{1,1};
        plot_mat(:,h) = sin_mat(:,i);
    end
    
    figure(i);
    for j=1:1:day_num
        color_index = mod(j,c_row)
        if color_index == 0
            color_index = color_index + 1;
        end
        plot(x_coor,plot_mat(:,j),'-mo',...
            'Color',color_mat(color_index,:),...
            'MarkerSize',3); 
        hold on
        pause(0.5);
    end

end

    for kk = 1:max_seg
        saveas(gcf,['C:\Users\uos\Documents\Gaussian_Process\Fig\fig_',num2str(kk)])
    end

end

