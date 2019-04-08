function littleInters_ru=calcuLittleInters(mean_ru,std_ru,result_ru)
serialAll_ru=unique([mean_ru-3*std_ru;mean_ru-2*std_ru;mean_ru-std_ru;mean_ru;mean_ru+std_ru;mean_ru+2*std_ru;mean_ru+3*std_ru]);
tmp=sort(serialAll_ru);
%for i=1:size(result_ru,2)
low=find(tmp==result_ru(1));
high=find(tmp==result_ru(2));
littleInters_ru=tmp(low:high);
