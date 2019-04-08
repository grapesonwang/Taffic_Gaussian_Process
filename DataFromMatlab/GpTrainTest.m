function [pred,se,ci] = GpTrainTest(x,y,xs,ys,X,Y)
%UNTITLED7 此处显示有关此函数的摘要
%   此处显示详细说明
gprMdl = fitrgp(x,y,'KernelFunction','squaredexponential',...
      'FitMethod','exact','PredictMethod','exact');

[pred,se,ci] = predict(gprMdl,X,'Alpha',0.01);

% disp('plotting')
% figure()
% set(gca, 'FontSize', 24)
% f = [ci(:,1); flipdim(ci(:,2),1)];
% fill([Y; flipdim(Y,1)], f, [7 7 7]/8)
% 
% hold on; plot(Y, pred, 'LineWidth', 2); plot(Y, ys, 'o', 'MarkerSize', 6)
% 
% grid on

end

