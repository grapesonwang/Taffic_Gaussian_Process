function [ new_x, new_y ] = TimeSeries(data_in, step, c_start, c_end)

%% This is for preparation of the inputs and outputs
c_col = c_end + 1;

x = data_in(:,c_start:c_end);
y = data_in(:,c_col);   % c_col is the last column, which is the output
[x_row, x_col] = size(x);

%x(:,1) = (linspace(1,num_row,num_row))';   % this is the linear time stamp
%x(:,1) = x(:,1);
%x = mapminmax(x,0,1);

new_row = x_row - step;
new_col = step + c_end - c_start + 1;
new_x = zeros(new_row, new_col);
new_y = zeros(new_row, 1);

temp_x = zeros(1,new_col);
for i = 1:1:new_row  
    temp_fetch = (y(i:1:i+step-1,1))';
    temp_x(1,1:step) = temp_fetch;
    temp_x(1,step+1:end) = x(i+step,:);
    temp_y(1,1) = y(i+step,1);
    
    new_x(i,:) = temp_x;
    new_y(i,:) = temp_y; 
end

end

