function [combine,combineProb]=combineLittleInters2(prob,inters)
linjie=0.2;
for i=1:length(prob)
    gailv(i)=sum(prob(1:i));
end
jiedian(1)=0;
% num=2;
% for i=1:length(gailv)
%     if 
for i=1:length(gailv)
    if gailv(i)>=linjie
        jiedian(2)=i;
        break;
    end
end
num=2;
for i=jiedian(2)+1:length(gailv)
    if gailv(i)-gailv(jiedian(num))>=linjie
        num=num+1;
        jiedian(num)=i;
    end
end
jiedian(length(jiedian)+1)=length(gailv);  %在概率序列中得到目标结点

jiedian;
for i=1:length(jiedian)-1
    combine(i,:)=[inters(jiedian(i)+1) inters(jiedian(i+1)+1)];
    combineProb(i,1)=sum(prob(jiedian(i)+1:jiedian(i+1)));
end
% combine(1,:)=[inters(1) inters(jiedian(1)+1)];
% combineProb(1,1)=sum(prob(1:jiedian(1)));
% for i=1:length(jiedian)-1
%     combine(i+1,:)=[inters(jiedian(i)+1) inters(jiedian(i+1)+1)];
%     combineProb(i+1,1)=sum(prob(jiedian(i)+1:jiedian(i+1)));
% end
% combine(length(jiedian)+1,:)=[inters(jiedian(end)+1) inters(end)];
% combineProb(length(combineProb)+1,:)=sum(prob(jiedian(end)+1:end));


        