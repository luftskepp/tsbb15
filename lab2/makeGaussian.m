function [lp] = makeGaussian(lpSize,standardDev)
% creates a normalized 2D Gaussian LP-filter of size lpSize with std
% standardDev
[x y] = meshgrid(-floor(lpSize/2):floor(lpSize/2));
lp = exp(-0.5*(x.^2 + y.^2)/standardDev^2);
lp = lp./sum(lp(:));
end