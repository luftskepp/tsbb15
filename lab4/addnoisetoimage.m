function [noiseim, imsnr] = addnoisetoimage(im,snr)
% snrdb = 10*log(Ps/Pn)
% log(Ps/Pn) = snrdb/10
% Ps/Pn  = exp(snrdb/10)
% Pn = Ps/exp(snrdb/10)

Ps = 1/(numel(im))*sum(im(:).^2);
Pn = Ps/10^(snr/10);
n = sqrt(Pn)*randn(size(im));
noiseim = im + n;


% snr for control:
if nargout>1
    imsnr = 10*log10(sum(noiseim(:).^2)/numel(noiseim)/var(n(:)));
end