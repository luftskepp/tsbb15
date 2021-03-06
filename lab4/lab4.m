% %% lab4
% % clear; close all;
% % initcourse 'TSBB15';
% addpath ../lab2 ../lab3 ../adfilt
%
% %% testCircle:
%
% testCircle
% % constants:
% c = 0.0001;
% delta = 1;
%
% imtmp = im;
%
% figure(1); clf;
% subplot(121); imshow(im,[]); axis image; axis off; title input;
% colormap jet;
% % restore:
%
% for kkk = 1%:10
%     % estimate tensor
%     [fx, fy] = regDerivative(im,1,1);
%     T = estimateTensor(fx,fy,1,1);
%
%     % diffusion tensor:
%     D = TtoD(T,c);
%
%     % hessian:
%     HL = estHessian(im,1,1);
%
%     % diffusion:
%     duds = diffusionTrace(D,HL);
%
%     imtmp = imtmp + delta*duds;
%     figure(1);
%     subplot(122);
%     imshow(imtmp,[]);colormap jet; axis image; axis off; title output;
%     % figure(2);
%     %subplot(121); imshow(T,[]); axis image; axis off; title T;
%     %subplot(122); imagesc(duds); axis image; axis off; title duds;
%     shg; pause(0.5);
% end
%
% %% IM ON A BOAT
% img = double(imread('boat.png'))/255;
%
% [fx, fy] = regDerivative(img,3,1);
% T = estimateTensor(fx,fy,3,1);
%
% % diffusion tensor:
% c = 1;
% D = TtoD(T,c);
%
% % hessian:
% HL = estHessian(img,3,1);
%
% % diffusion:
% duds = diffusionTrace(D,HL);
%
% imtmp = img + duds;
% figure(2)
% subplot(221); imshow(img,[0 1]); colormap bone; axis image; axis off; title input;
% subplot(222); imshow(imtmp,[0 1]); colormap bone; axis image; axis off; title output;
% subplot(223); imagesc(T); axis image; axis off; title T;
% subplot(224); imagesc(duds); axis image; axis off; title duds;
% shg; pause(0.5);
%

%%%%%%%%%%%%%%%
%% Evaluation %
%%%%%%%%%%%%%%%
img = double(imread('cameraman.tif'))/255;
% SNR = 3
[im1, snr1] = addnoisetoimage(img,3,1);
% SNR = 5
[im2, snr2] = addnoisetoimage(img,10,1);
% SNR = 7
[im3, snr3] = addnoisetoimage(img,20,1);

% params:
c = 0.0001;
delta = 0.05;
fsize = 1;
stdder = .5;
er=[];

imtmp = im3;
figure(3);
subplot(121);
imagesc(im3); title orig; axis image; axis off; colormap gray;
for kkk = 1:1000
    % estimate tensor
    [fx, fy] = regDerivative(imtmp,fsize,stdder);
    T = estimateTensor(fx,fy,fsize,stdder);
    
    % diffusion tensor:
    D = TtoD(T,c);
    
    % hessian:
    HL = estHessian(imtmp,fsize,stdder);
    
    % diffusion:
    duds = diffusionTrace(D,HL);
    
    imtmp = imtmp + delta*duds;
    figure(3);
    subplot(122);
    imshow(imtmp,[]);colormap gray; axis image; axis off; title(sprintf('output iter: %d',(kkk)));
    % figure(2);
    %subplot(121); imshow(T,[]); axis image; axis off; title T;
    %subplot(122); imagesc(duds); axis image; axis off; title duds;
    %if mod(kkk,10)==0
    %    shg; pause();
    %end
    er=[er sum(sum(img-imtmp).^2)];
end
figure;
plot(er)
%
% imshow(imtmp,[]);colormap gray; axis image; axis off; title(sprintf('output iter: %d',(kkk)));

%%%%%%%%%%%%
%% multiplicative
%%%%%%%%%%%
img = double(imread('cameraman.tif'))/255;
% SNR = 3
[im1, snr1] = addnoisetoimage(img,3,0);
% SNR = 5
[im2, snr2] = addnoisetoimage(img,5,0);
% SNR = 7
[im3, snr3] = addnoisetoimage(img,10,0);

% params:
c = 0.0001;
delta = 0.1;
fsize = 2;
stdder = .5;

imtmp = im3;
figure(4);
subplot(121);
imagesc(imtmp); title orig; axis image; axis off; colormap gray;
for kkk = 1:500
    % estimate tensor
    [fx, fy] = regDerivative(imtmp,fsize,stdder);
    T = estimateTensor(fx,fy,fsize,stdder);
    
    % diffusion tensor:
    D = TtoD(T,c);
    
    % hessian:
    HL = estHessian(imtmp,fsize,stdder);
    
    % diffusion:
    duds = diffusionTrace(D,HL);
    
    imtmp = imtmp + delta*duds;
    figure(4);
    subplot(122);
    imshow(imtmp,[]);colormap gray; axis image; axis off; title(sprintf('output iter: %d',(kkk)));
    % figure(2);
    %subplot(121); imshow(T,[]); axis image; axis off; title T;
    %subplot(122); imagesc(duds); axis image; axis off; title duds;
    % if mod(kkk,10)==0
    %    shg; pause();
    %end
end

%%%%%%%%%%%%%%%%%
%% INPAINTING
%%%%%%%%%%%%%%%%
img = double(imread('boat.png'))/255;

%img = img(350:400,300:350);
%imgdown = img;%(1:2:end,1:end);
%imgup = zeros(size(img));
%imgup(1:2:end,1:end) = imgdown;

imgup = img;%(1:50,200:250);
immask = 0.1<rand(size(img));
imgup = imgup.*immask;
%figure(5); subplot(121);imagesc(img); axis image;
%subplot(122); imagesc(imgup); axis image;

%
alpha = 1;
lambda = 0.0003;
fsize = 1; std = .5;
mask = immask;

g = imgup;
u = g;

figure(7); subplot(121);imagesc(imgup); axis image; title orig;

for iter = 1:500
    deltaim = inpainting(g,u,mask,lambda,fsize,std);
    u = u - alpha*deltaim;
end
subplot(122);
imshow(u,[0 1]);colormap gray; axis image; axis off; title(sprintf('restored iter: %d',(iter)));
