
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

                   
                temp_vec = [2016 i j hour minute 0];
                temp_str = datestr(temp_vec);
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
xlswrite('./training_data/data_vec.xlsx', date_vec, 'Sheet1')
