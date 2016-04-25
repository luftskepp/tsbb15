%% lab4
clear; close all;
%initcourse 'TSBB15';
addpath ../lab2 ../lab3 ../adfilt
img = double(imread('boat.png')/255);

%% Structure tensor:
[fx fy] = regDerivative(img,7,3);
T = estimateTensor(fx,fy,7,3);

% diffusion tensor:
c = 1;
D = TtoD(T,c);

% hessian:
HL = estHessian(img,7,3);

% diffusion:
duds = diffusionTrace(D,HL);

%% test:

testCircle
% constants:
c = 10;

figure(1); clf;
subplot(221); imagesc(im); colormap bone; axis image; axis off; title input;
% restore:
imtmp = im;
delta = 1;
for i = 1:10
    % estimate tensor
    [fx, fy] = regDerivative(im,1,1);
    T = estimateTensor(fx,fy,1,1);
    
    % diffusion tensor:
    D = TtoD(T,c);

    % hessian:
    HL = estHessian(im,7,3);
    
    % diffusion:
    duds = diffusionTrace(D,HL);

    imtmp = imtmp + delta*duds;
    subplot(222); 
    imagesc(imtmp); colormap bone; axis image; axis off; title output;
    subplot(223); imagesc(T); axis image; axis off; title T;
    subplot(224); imagesc(duds); axis image; axis off; title D;
    shg; pause(0.5);
end

    %% 