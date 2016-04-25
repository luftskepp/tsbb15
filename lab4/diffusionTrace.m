function duds = diffusionTrace(D, HL)
D11 = D(:,:,1);
D12 = D(:,:,2);
D22 = D(:,:,3);

H11 = HL(:,:,1);
H12 = HL(:,:,2);
H22 = HL(:,:,3);

% duds = trace(D H L):
duds = D11.*H11 + D12.*H12 + D12.*H12 + D22.*H22;
end