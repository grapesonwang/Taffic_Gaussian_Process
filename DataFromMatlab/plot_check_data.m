% clear all
% clc
load('2016speedandcounts_correct.mat');
load('SANTANDER_NETWORK_INFO_AIMSUN.mat'); 
figure 
dw = [Sections(3152).X;Sections(3152).Y]';
[row,col] = size(dw);
plot(dw(1,1),dw(1,2),'ro');
hold on
for i = 2:1:row
plot(dw(i,1),dw(i,2),'b^');
pause(1)
hold on
 end
% lfx = SectionsGeo(2396).lfx;
% lfy = SectionsGeo(2396).lfy;
% ltx = SectionsGeo(2396).ltx;
% lty = SectionsGeo(2396).lty;
% rfx = SectionsGeo(2396).rfx;
% rfy = SectionsGeo(2396).rfy;
% rtx = SectionsGeo(2396).rtx;
% rty = SectionsGeo(2396).rty;
% fx = SectionsGeo(2396).fx;
% fy = SectionsGeo(2396).fy;
% tx = SectionsGeo(2396).tx;
% ty = SectionsGeo(2396).ty;
% x = [lfx,ltx,rfx,rtx,fx,tx];
% y = [lfy,lty,rfy,rty,fy,ty];
% 
% for i = 1:1:6
% plot(x(i),y(i),'ro');
% pause(0.5)
% hold on
%  end