function [noiseim, imsnr] = addnoisetoimage(im,snr,AWGN)
% snrdb = 10*log(Ps/Pn)
% log(Ps/Pn) = snrdb/10
% Ps/Pn  = exp(snrdb/10)
% Pn = Ps/exp(snrdb/10)

Ps = 1/(numel(im))*sum((im(:) - mean(im(:))).^2);
Pn = Ps/10^(snr/10);
n = sqrt(Pn)*randn(size(im));

if AWGN
    noiseim = im + n;
else
    imt = log(im);
    imt = imt + n;
    noiseim = exp(imt);
end

% snr for control:
if nargout>1
    imsnr = 10*log10(sum( ( noiseim(:) - mean(noiseim(:)) ).^2)/numel(noiseim)/var(n(:)));
end