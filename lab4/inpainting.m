function [dimout] = inpainting(g, u, mask, lambda, fsize, std)

% du/dx du/dy
[ux, uy] = regDerivative(u, fsize, std);

% div grad u
Hu = estHessian(u, fsize, std);

uxx = Hu(:,:,1);
uxy = Hu(:,:,2);
uyy = Hu(:,:,3);

divgradu = (uxx.*uy.^2 - 2*uxy.*ux.*uy + uyy.*ux.^2)./ ((sqrt( ux.^2 + uy.^2)).^3 + eps); 
% output
dimout = mask.*(u - g) - lambda*divgradu;
end