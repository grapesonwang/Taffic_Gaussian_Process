function seg_len = SegLength(cood_vec)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
[row,col] = size(cood_vec);
last_col = cood_vec(:,col);
%num_NaN = length(isnan(last_col));
if col<4
    disp('col<4');
end
dist = 0;
counter = 0;
if col <= 4
    counter = counter + 1;
    for i = 2:1:(col-2)
        dist = dist + sqrt(power(cood_vec(1,i+1)-cood_vec(1,i),2) + ...
            power(cood_vec(2,i+1)-cood_vec(2,i),2));
    end
else
    counter = counter + 1;
    for i = 2:1:(col-3)
        dist = dist + sqrt(power(cood_vec(1,i+1)-cood_vec(1,i),2) + ...
            power(cood_vec(2,i+1)-cood_vec(2,i),2));
    end
end
seg_len = dist;
end
