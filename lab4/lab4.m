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
[fx, fy] = regDerivative(im,7,3);
T = estimateTensor(fx,fy,7,3);

% diffusion tensor:
c = 1;
D = TtoD(T,c);

% hessian:
HL = estHessian(im,7,3);

% diffusion:
duds = diffusionTrace(D,HL);


% restore:
imtmp = im;
delta = 1;
for i = 1:10
    imtmp = imtmp + delta*duds;
    imagesc(imtmp);
    shg; pause(0.5);
end
imagesc(im)

    %% 