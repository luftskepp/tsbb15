%% init lab
%initcourse('TSBB15');
%load('data.xy');
%addpath optimization BAdino BAdino/imgs;
%% load imgs
% im1num = 1;
% im2num = 2;
% img1 = imread(sprintf('viff.%03d.ppm',im1num-1));
% img2 = imread(sprintf('viff.%03d.ppm',im2num-1));
close all;
clear;
img1 = double(imread('img1.png'))/255;
img2 = double(imread('img2.png'))/255;
%% find interest points:
%x1 = detectSURFFeatures(rgb2gray(img1),'ROI',[10 10 size(img1,2)-10 size(img1,1)-10]);
%x2 = detectSURFFeatures(rgb2gray(img2),'ROI',[10 10 size(img2,2)-10 size(img2,1)-10]);
%[feat1, points1] = extractFeatures(img1,x1);
%[feat2, points2] = extractFeatures(img2,x2);
% for ii = 1:size(data,1)
%     if(data(ii,2*im1num-1)~=-1 && data(ii,2*im2num-1)~=-1)
%         x1 = [x1 [data(ii,2*im1num-1); data(ii,2*im1num)] ];
%         x2 = [x2 [data(ii,2*im2num-1); data(ii,2*im2num)] ];
%     end
% end
[H1, dIm1] = harris(rgb2gray(img1),5);
[H2, dIm2] = harris(rgb2gray(img2),5);

H1_sup = non_max_suppression(H1,5);
H2_sup = non_max_suppression(H2,5);
H1_sup(H1_sup<0.01*max(H1_sup(:))) = 0;
H2_sup(H2_sup<0.01*max(H2_sup(:))) = 0;

figure;
subplot(221); imagesc(H1); axis image; title H1;
subplot(222); imagesc(H2); axis image; title H2;
subplot(223); imagesc(H1_sup); axis image; title H1sup;
subplot(224); imagesc(H2_sup); axis image; title H2sup;

% extract points
[r1, c1] = find(H1_sup > 0);
[r2, c2] = find(H2_sup > 0);

rl1 = cut_out_rois(rgb2gray(img1),c1,r1);
rl2 = cut_out_rois(rgb2gray(img2),c2,r2);

match_matrix = matchroi(rl1,rl2);%,r1,r2,c1,c2,0.1);
[~,ind1,ind2] = joint_min(match_matrix);

x1 = [c1(ind1)'; r1(ind1)'];
x2 = [c2(ind2)'; r2(ind2)'];

figure;
show_corresp(img1,img2,x1,x2); title 'point correspondence';
% subplot(121); imagesc(img1); axis image; hold on; plot(x1(:,1),x1(:,2),'rx'); title img1; axis image;
% subplot(122); imagesc(img2); axis image; hold on; plot(x2(:,1),x2(:,2),'rx'); title img2; axis image;
%% estimate F0 (RANSAC)
N = inf; sample_count = 0;
p = 0.99;
total_num = size(x2,2);
t = 3;
Npts = size(x1,2);
Fhat = zeros(3);
Consensus = [];
%while N > sample_count
for k = 1:1000
    num_inliers = 0;
    Consensustmp = [];
    % random sample:
    P = randperm(Npts,8);
    xl = x1(:,P);
    xr = x2(:,P);
    % compute F0: 8 point algorithm
    F0 = fmatrix_stls(xl,xr);
    
    % comp. epipolar lines
    ll = F0*[x2; ones(1,Npts)];
    lr = F0'*[x1; ones(1,Npts)];
    % compute distances and inliers:
    for i = 1:Npts
        ll(:,i) = ll(:,i)./sqrt(sum(ll(1,i).^2+ll(2,i).^2)).*-(sign(ll(3,i)));
        lr(:,i) = lr(:,i)./sqrt(sum(lr(1,i).^2+lr(2,i).^2)).*-(sign(lr(3,i)));
        d1(i) = [x1(:,i); 1]'*ll(:,i);
        d2(i) = [x2(:,i); 1]'*lr(:,i);
        if(abs(d1(i))<t && abs(d2(i)<t))
            num_inliers = num_inliers+1;
            Consensustmp = [Consensustmp i];
        end
    end
    
    if num_inliers > length(Consensus)
        Fhat = F0;
        Consensus = Consensustmp;
        eps = 1-num_inliers/Npts;
        N = log(1-p)/log(1 - (1-eps)^8);
    end
    
    sample_count = sample_count +1;
    
end
Fhat
figure;
subplot(121);
imagesc(img1);axis image; title 'RANSAC img 1'; hold on; plot_eplines(Fhat,x2(:,Consensus),[1 size(img1,1) 1 size(img2,2)]);
plot(x1(1,Consensus),x1(2,Consensus),'rx');
subplot(122);
imagesc(img2);axis image; title 'RANSAC img 2'; hold on; plot_eplines(Fhat',x1(:,Consensus),[1 size(img1,1) 1 size(img2,2)]);
plot(x2(1,Consensus),x2(2,Consensus),'rx');
inlier_ratio = length(Consensus)/Npts;
sample_count;


%% GOLD STANDARD
[C1, C2] = fmatrix_cameras(Fhat);

Xhat = [];
for ii = 1:length(Consensus)
    xhat = triangulate_optimal(C1,C2,[x1(:,Consensus(ii));1],[x2(:,Consensus(ii));1]);
    xhat = xhat./xhat(4);
    Xhat = [Xhat xhat];
end

x0 = [reshape(C1,[],1); reshape(Xhat(1:3,:),[],1)];
% minimise cost
costfun = @(x)fmatrix_residuals_gs1(x,x1(:,Consensus),x2(:,Consensus));
X = lsqnonlin(costfun,x0);


%%
C1 = reshape(X(1:12),3,4);
Xhatfinal = reshape(X(13:end),3, []);
F = fmatrix_from_cameras(C1,C2)

figure;
subplot(121);
imagesc(img1);axis image; title 'GOLD 1'; hold on; plot_eplines(F,x2(:,Consensus),[1 size(img1,1) 1 size(img2,2)]);
plot(x1(1,Consensus),x1(2,Consensus),'rx');
subplot(122);
imagesc(img2);axis image; title 'GOLD 2'; hold on; plot_eplines(F',x1(:,Consensus),[1 size(img1,1) 1 size(img2,2)]);
plot(x2(1,Consensus),x2(2,Consensus),'rx');
%%
ransac_err = sum(fmatrix_residuals(Fhat,x1(:,Consensus),x2(:,Consensus)).^2,2)
gold_err = sum(fmatrix_residuals(F,x1(:,Consensus),x2(:,Consensus)).^2,2)
%%
%pc = pointCloud(Xhatfinal');
%pcshow(pc)