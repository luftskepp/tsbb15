% create test image for the restoration lab
[x,y] = meshgrid(-1:.01:1);
im = (x.^2 + y.^2) < .5;
im = im + (rand(size(im))-.5)*.1;

% use same color axis in all images
colorAxis = [min(im(:))-.1 max(im(:))+.1];

figure(1);
imagesc(im, colorAxis); colorbar;
title('Image with noise');

