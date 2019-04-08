function [fin_index] = final_index(sen_index,boundry,TIME_SLOT,SEN_NUM)
[row, col] = size(sen_index');
f_row = row * TIME_SLOT * boundry;
step = length(sen_index);
fin_index = zeros(f_row, col);
for dd = 1:1:boundry
    global_offset = (dd-1) * TIME_SLOT * SEN_NUM;
    temp_common = (dd-1) * TIME_SLOT * step;
    for tt = 1:1:TIME_SLOT
        local_offset = (tt-1) * SEN_NUM;
        temp_index = global_offset + local_offset + sen_index;
        
        temp_start = temp_common + (tt-1) * step + 1;
        temp_end = temp_common + tt * step;
        fin_index(temp_start:temp_end,:) = temp_index;
    end
end
end

