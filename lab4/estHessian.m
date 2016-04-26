function hessian = estHessian(im,fsize,std)
% Calculates the hessian of the image


H11 = [ 0 0 0 ; 1 -2 1; 0 0 0]./4;
H22 = H11'./4;
H12 = 1/4*[ 1 0 -1; 0 0 0 ; -1 0 1 ];

g = makeGaussian(fsize,std);

fxx = conv2(im,H11,'same');
fxy = conv2(im,H12,'same');
fyy = conv2(im,H22,'same');

% fxx = conv2(fxx,g,'same');
% fxy = conv2(fxy,g,'same');
% fyy = conv2(fyy,g,'same');

hessian = cat(3, fxx, fxy, fyy);
end