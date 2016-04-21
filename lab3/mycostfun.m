function [ res ] = mycostfun( x0, xt, xi )
%GSCOST Summary of this function goes here
%   Detailed explanation goes here
% extract initial f0 and X

r = fmatrix_residuals_gs1( x0, xt, xi );
res = r.^2;
res = sum(res,1);
res = res';
end
