% How to creat folders 
clc ;
clear ;

for k=1:2
failname = dir('C:\Users\uos\Documents\Gaussian_Process\DataFromMatlab\ssdf_data\train_data\*.*') ;
[row col ] = size(failname);
for i =3:row    
    path = ['C:\Users\uos\Documents\Gaussian_Process\DataFromMatlab\ssdf_data\train_data\' failname(i).name] ;
    str = ['ui_' num2str(8*(k-1)+i-2)];
   savepath = ['C:\Users\uos\Documents\Gaussian_Process\DataFromMatlab\ssdf_data\train_data\' str] ; 
    copyfile(path,savepath);    
end;
end;
figure(1)