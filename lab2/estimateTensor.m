function [T] = estimateTensor(fx,fy,lpSize,standardDev)
% estimates the structure tensor from the regularized derivatives.
% estimate Tensor
T = zeros([size(fx),3]);
T11 = fx.*fx;
T12 = fx.*fy; % T symmetric => T21 = T12;
T22 = fy.*fy;
% make Gaussian lp-filter
lp = makeGaussian(lpSize,standardDev);

T11 = conv2(T11,lp,'same');
T12 = conv2(T12,lp,'same');
T22 = conv2(T22,lp,'same');

T(:,:,1) = T11;
T(:,:,2) = T12;
T(:,:,3) = T22;
end