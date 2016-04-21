%% lesson 1 - image processing in MATLAB
initcourse TSBB15;
%% 2.1
t = 2*pi*(0:9)/10;
x = sin(t);
plot(t,x,'--hm'); % -- dashed line, h hexagon, m magenta

%% 2.2
sin(1)
sin = 42 % sin gets overloaded
sin(1) % = 42
which sin % variable
clear sin
which sin % built-in func

%% 2.3 
% needs initcourse
type timedloops
tic;
timedloops
toc
%% 2.4
A = rand(9,9)
A(2, 7)
A(3:6, 1:2:5)
A([1 1 5 5 3 1], :)
A(end:-2:1, 1:2:end)
A(17) % 17 element, columnwise,
A(:) % all elements, columnwise
b = [1 7 3]
A(b,5) = 97
A(4, 7:9) = b
A(A<0.5) = 0
mask = A==0
A(mask) = 1:sum(mask(:))

%% 2.5
A = 1:64
reshape(A, 16, 4)
reshape(A, [4 4 4])
reshape(A, 4, [], 2, 2)
B = [1 7 2 49]
repmat(B, 10, 2)
repmat(B, 4:-1:2)

%% 2.6
imtest = 128*rand(128,128)+64;
type0 = 1;
figure(1)
imagebw(imtest, type0);
figure(2)
imagebw(imtest, 0);

%% 3
[x,y]=meshgrid(-128:127,-128:127);
figure(2)
subplot(1,2,1);imagebw(x,1)
subplot(1,2,2);imagebw(y,1)
r = sqrt(x.^2 + y.^2);
figure(3);
imagebw(r,1)

p1 = cos(r/2);
figure(4);
subplot(121);imagebw(p1,1);
P1 = abs(fftshift(fft(ifftshift(p1))));
subplot(122); imagebw(P1,1);

p2 = cos(r.^2/200);
P2 = abs(fftshift(fft(ifftshift(p2))));
figure(5);
subplot(121);imagebw(p2,1);
subplot(122); imagebw(P2,1);

p2=p2.*(r.^2/200<22.5*pi);
P2 = (fftshift(fft(ifftshift(p2))));
figure(6);
subplot(121);imagebw(p2,1);
subplot(122); imagebw(abs(P2),1);

%% 4
u=x/256*2*pi;
v=y/256*2*pi;
R = zeros(size(P2));
R(sqrt(u.^2 + v.^2)<=pi/4) = 1;
%R(abs(u)>pi/4) = 0;
%R(abs(v)>pi/4) = 0;

PR = P2.*R;
pr = ifftshift(ifft(fftshift(PR)));

figure(7)
subplot(121); imagebw(pr,1);
subplot(122); imagebw(abs(PR),1);

%% time domain
lp = ones(1,9)/9;
p2fs = conv2(lp,lp',p2);
figure(8); imagebw(p2fs,1);

% gaussian
sigma = 3;
lp = exp(-0.5*([-6:6]/sigma).^2);
lp = lp/sum(lp);
p2fs = conv2(lp,lp',p2);
figure(9); imagebw(p2fs,1);

%% 5
A = im2double(imread('paprika.png'));
%size(A)
figure(10)
subplot(2,2,1);image(A);axis image;
for k=1:3,subplot(2,2,1+k);imagebw(A(:,:,k)*255,0);end;

Ag = rgb2gray(A);
subplot(221);imagebw(Ag,1); axis image;

%% 5.1
df = -1/sigma^2*[-6:6].*lp;
fx=conv2(lp,df',p2,'same');
fy=conv2(df,lp',p2,'same');
z=fx+1i*fy;

figure(11)
subplot(1,2,1);gopimage(z);axis image
z2=abs(z).*exp(1i*2*angle(z));
subplot(1,2,2);gopimage(z2);axis image

figure(12);
imagebw(abs(z),1);

%% 5.2
T=zeros(256,256,3);
T(:,:,1)=fx.*fx;
T(:,:,2)=fx.*fy;
T(:,:,3)=fy.*fy;
subplot(1,2,1);image(tens2RGB(T));axis image

sigma = 5;
lp=exp(-0.5*([-10:10]/sigma).^2);
Tlp=zeros(256,256,3);
Tlp(:,:,1)=conv2(lp,lp',T(:,:,1),'same');
Tlp(:,:,2)=conv2(lp,lp',T(:,:,2),'same');
Tlp(:,:,3)=conv2(lp,lp',T(:,:,3),'same');
subplot(1,2,2);image(tens2RGB(Tlp));axis image

% sigma = 5 gives good result;
% cos2a = t11-t22;
% sin2a = 2t12;

%% 5.3
load mystery_vector.mat
[max_val, max_ind] = max(mystery_vector)
mystery_image = reshape(mystery_vector,240,[]);

[yy, xx] = ind2sub(size(mystery_image),max_ind)
mystery_image(yy, xx)

%% 
clearvars;
load mystery_vector.mat
mystery_image = reshape(mystery_vector,240,[]);

sobelx = [1 0 -1; 2 0 -2; 1 0 -1];

T = convmtx2(sobelx,size(mystery_image));
tic;
im2 = reshape(T*mystery_vector, size(sobelx)+size(mystery_image)-1);
toc

figure(1)
subplot(121)
imshow(im2,[]);

tic;
im3 = conv2(mystery_image,sobelx);
toc
subplot(122)
imshow(im3,[]);

%% 6
copyfile('/site/edu/bb/ComputerVision/matlab/debug/*','~/Matlab/tsbb15/lesson1/')
%%


