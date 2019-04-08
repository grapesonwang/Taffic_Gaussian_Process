function [str] = vec2str_sim(temp_index)
temp_name = '';
for i = 1:1:length(temp_index)
    temp_name = strcat(temp_name,num2str(temp_index(1,i)),'_');
end
str = temp_name;
end

