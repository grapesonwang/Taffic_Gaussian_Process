function return_cell = ShrinkCell(temp_cell,temp_mat,temp_pos)
%UNTITLED12 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
[row,col] = size(temp_mat);
cell_mat = temp_cell{1,1};

for i = 1:1:length(temp_pos)
     temp_mat(:,i) = cell_mat(:,temp_pos(1,i)); 
end
return_cell{1,1} = temp_mat;
end

