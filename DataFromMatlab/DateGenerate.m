function [  ] = DateGenerate()
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明

date_vec = [];
for i = 6   % month//should be 1:12
    for j = 6:26  % day // should be 1:31
        for n = 1:96 % time slot // each 15 minutes
            try
                time = n*15-15;
                if(time>0 && mod(time,60)==0)
                    minute = 0;
                    hour = ceil(time/60);
                else
                    minute = mod(time,60);
                    hour = ceil(time/60)-1;
                end
                if(hour==-1)
                    hour=0;
                end       
                temp_vec = [0 2016 i j hour minute];
                trans_vec = [2016 i j hour minute 0];
                temp_str = datestr(trans_vec);
                [week_day_num, week_day_name] = weekday(temp_str); 
                if week_day_num < 2
                    week_day_num = week_day_num + 6;
                else
                    week_day_num = week_day_num - 1;
                end
                    
                fin_vec = [temp_vec week_day_num];
                date_vec = [date_vec; fin_vec];  
            end
        end
    end
end
[row, col] = size(date_vec);
date_vec(:,1) = ([1:row])';
select_date_vec = [1 2 3 4 5 6 7];
selected_date_vec = date_vec(:, select_date_vec);
xlswrite('./training_data/embd_p/data_vec.xlsx', date_vec, 'Sheet1')
xlswrite('./training_data/embd_p/selected_date_vec.xlsx', selected_date_vec, 'Sheet1')

end

