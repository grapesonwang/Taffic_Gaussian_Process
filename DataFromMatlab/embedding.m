clear all;
clc
% gspace = xlsread('./matlab_with_R/gspace.xlsx','A1:C295');
% weight = xlsread('./matlab_with_R/weight.xlsx','A1:C295');
gspace = xlsread('./matlab_with_R/gspace.xlsx');
weight = xlsread('./matlab_with_R/weight.xlsx');
embd = gspace .* weight;


% scatter3(embd(:,1),embd(:,2),...
%          embd(:,3),20);  
%% Following codes are used to verify the embedding results
A = pdist(embd, 'Euclidean');
m = length(A);
n = (-1+sqrt(1+8*m))/2 ; % Computing the dim of upper triangular matrix
AA = zeros(n,n);
% transform the vector into a upper triangular matrix
for i = 1:n
    for j = i:n
        index = sum(n:-1:n-i+2)+j-i+1;
        AA(i,j) = A(index);
    end
end
AA = AA';
res_matrix = zeros(n+1, n+1);
res_matrix(2:n+1,1:n) = AA;
res_matrix = res_matrix + res_matrix';

[mds_2D,stress] = cmdscale(res_matrix,3);
xlswrite('./matlab_with_R/mds_2D.xlsx', mds_2D, 'Sheet1')

figure;
%plot(mds_2D, 'r.');
scatter3(embd(:,1),embd(:,2),...
         embd(:,3),20); 
figure;
%plot(mds_2D, 'r.');
scatter3(mds_2D(:,1),mds_2D(:,2),...
         mds_2D(:,3),20);