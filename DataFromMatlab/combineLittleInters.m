function [combine,gailv]=combineLittleInters(prob,inters)
% maxProb=max(prob);
% xuhao=find(prob==maxProb);
% middle=ceil(length(xuhao)/2);
% probility=prob(xuhao(middle));
% qidian=xuhao(middle);
% jiedian=xuhao(middle)+1;
% for i=1:length(prob)/2
%     probility=probility+prob(xuhao(middle)-i)+prob(xuhao(middle)+i);
%     qidian=xuhao(middle)-i-1;
%     jiedian=xuhao(middle)+i+1;
%     if prob>0.95
%         break;
%     end
% end
% gailv=probility;
% combine=[inters(qidian) inters(jiedian)]';


xuhao=find(prob>=0.005);
qidian=xuhao(1);
jiedian=xuhao(end);
probility=0;
for i=qidian:jiedian
    probility=probility+prob(i);
end
combine=[inters(qidian) inters(jiedian+1)]';
gailv=probility;
% former=xuhao(1);
% gailv=prob(former);
% for i=2:length(xuhao)
%     m=xuhao(i);
%     if m-former==1
%         jiedian=inters(m+1);
%         gailv=gailv+prob(m);
%     end
% end
% combine=[qidian jiedian]';


% 
% kaishi=0;jiesu=0;
% prob=0;
% for i=1:length(predictProb)
%     if predictProb(i)>0.01
%         kaishi=i;jiesu=i+1;
        