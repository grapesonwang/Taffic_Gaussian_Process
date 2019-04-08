N = 10;
index = 200:200+N; index = 1:251;
scale = 300;
x = scale*xData(index)'; 
y  =  zxData(index)';
Ns = 1000;
xs = linspace(min(x), max(x), Ns)';

%meanfunc = [];                    % empty: don't use a mean function
meanfunc = @meanConst;                    % empty: don't use a mean function
covfunc = @covSEiso;              % Squared Exponental covariance function
likfunc = @likGauss;              % Gaussian likelihood
%meanfunc = 2.5;

%hyp = struct('mean', 2.5*[], 'cov', 0.01+[0 0], 'lik', -1*7);

hyp = struct('mean', 3, 'cov', [0 0], 'lik', -10);
hyp2 = minimize(hyp, @gp, -1000, @infGaussLik, meanfunc, covfunc, likfunc, x, y);
% hyp2.lik = -5;
% hyp2.cov(1) = 1.274;%0.6;
% hyp2.cov(2) = -0.978*-2;
% disp('finished')

% predict and plot
[mu s2] = gp(hyp2, @infGaussLik, meanfunc, covfunc, likfunc, x, y, xs);

%s2 = mean(s2)*2*ones(Ns,1); % 0.0065;
s2 = mean(s2)*0.5*ones(Ns,1); % 0.0065;
%s2 = s2+0.0065/4
f = [mu+2*sqrt(s2); flipdim(mu-2*sqrt(s2),1)];
fill([xs/scale; flipdim(xs/scale,1)], f, [7 7 7]/8)
hold on; plot(xs/scale, mu); plot(x/scale, y, '+')
hold off



%axis([0 spann*pi -2 2])
set(gca, 'fontsize', 15)
legend('conf band', 'mean f', 'datapoint')

xlabel('x (mm)'), ylabel('z (mm)')