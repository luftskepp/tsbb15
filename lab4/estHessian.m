function hessian = estHessian(im,fsize,std)

[fx,fy] = regDerivative(im,fsize,std);
[fxx,fxy] = regDerivative(fx,fsize,std);
[~,fyy] = regDerivative(fy,fsize,std);

H11 = fxx;
H12 = fxy;
H22 = fyy;

hessian = cat(3, H11, H12, H22);
end