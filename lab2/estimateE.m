function [E] = estimateE(im1,im2,fx,fy,lpSize,standardDev)
% estimates the error e for KLT;
E = zeros([size(im1),2]);
lp = makeGaussian(lpSize,standardDev);
im1lp = conv2(im1,lp,'same');
im2lp = conv2(im2,lp,'same');
E(:,:,1) = (im1lp - im2lp).*fx;
E(:,:,2) = (im1lp - im2lp).*fy;
end