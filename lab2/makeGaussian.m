function [lp] = makeGaussian(lpSize,standardDev)
% creates a normalized 2D Gaussian LP-filter of size 2*lpSize+1 with std
% standardDev
[x, y] = meshgrid(-lpSize:lpSize);
lp = exp(-0.5*(x.^2 + y.^2)/standardDev^2);
lp = lp./sum(lp(:));
end