function result=calcuLittleInters2(predictLittleInters,littleInters,real,predict)
serialAll=[];
if ~(predictLittleInters(1)>predict(2)||predictLittleInters(end)<predict(1))
    serialAll=[serialAll predictLittleInters'];
end
if ~(littleInters(1)>predict(2)||littleInters(end)<predict(1))
    serialAll=[serialAll littleInters'];
end
if ~(real(1)>predict(2)||real(end)<predict(1))
    serialAll=[serialAll real'];
end
%serialAll=unique([data(1,:) data(2,:)]);
tmp=sort(unique(serialAll));
%for i=1:size(result_ru,2)
low=find(tmp==predict(1));
high=find(tmp==predict(2));
result=tmp(low:high)';