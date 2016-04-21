%% TSBB15 - LAB 2
% init
clearvars
addpath ./forwardL/
%% Kanade-Lukas, motion estimation
% load images
im1 = double(imread('forwardL7.png'))/255;
im2 = double(imread('forwardL8.png'))/255;

% calculate derivatives
lpSize = 9; standardDev = 2;
[im2dx, im2dy] = regDerivative(im2,lpSize,standardDev);
% calculate error matrix for Kanade Lukas eq.
errorMatrix = estimateE(im1,im2,im2dx,im2dy,lpSize,standardDev);
% calculate structure tensor
structureTensor = estimateTensor(im2dx,im2dy,lpSize,standardDev);
% solve KL eq.
[V,C] = KLeq(structureTensor,errorMatrix,lpSize,standardDev);
% interpolate new image
im1interpol = interpolIm(im2,V);
% create edgemask
imEdgeMask = zeros(size(im1interpol));
imEdgeMask(11:end-10,11:end-10) = 1;
% calculate difference images
diffIm = conv2(im1,makeGaussian(lpSize,standardDev),'same') - conv2(im2,makeGaussian(lpSize,standardDev),'same');
diffIm = diffIm.*imEdgeMask;

diffImInter = conv2(im1interpol,makeGaussian(lpSize,standardDev),'same') - conv2(im1,makeGaussian(lpSize,standardDev),'same');
diffImInter = diffImInter.*imEdgeMask;
% calculate total error
errorInterpol = sum(abs(diffImInter(:)));
errorNoInterpol = sum(abs(diffIm(:)));

% calculate error between original images
