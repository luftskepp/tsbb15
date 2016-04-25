function [fx, fy] = regDerivative(im, lpSize, standardDev)
% calculates the regularized derivatives fx, fy of an image im;

% make Gaussian of size 2*lpSize+1 with std standardDev;
x = -lpSize:lpSize;
lp = exp(-0.5.*x.^2/standardDev^2);
lp = lp/sum(lp(:)); % normalize
% calc regularized 1D sobel
df = -x.*lp;
% calculate regularized derivatives
fx = conv2(lp,df',im,'same');
fy = conv2(df,lp',im,'same');

end





