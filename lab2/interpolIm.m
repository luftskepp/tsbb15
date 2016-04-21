function [imInterpolated] = interpolIm(im, V)
% interpolates the image with the displacement matrix V, V(:,:,1) contains
% displacement in x-direction and V(:,:,2) in y-direction

% extract displacement matrices
Vx = V(:,:,1);
Vy = V(:,:,2);

% make meshgrid with coordinates
[X, Y] = meshgrid(1:size(im,2),1:size(im,1));

% remove displacements that are outside the image,
Vx(X+Vx < 1 | X+Vx > size(im,2)) = 0;
Vy(Y+Vy < 1 | Y+Vy > size(im,1)) = 0;

% make meshgrid with interpolation coordinates
Xq = X+Vx;
Yq = Y+Vy;

% interpolatenew image;
imInterpolated = interp2(X,Y,im,Xq,Yq);

% remove eventual nans
imInterpolated(isnan(imInterpolated))=0;

end


