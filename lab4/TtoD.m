function D = TtoD(T,c)
% D = alpha1*E1*E1' + alpha2*E2*E2';

T11 = T(:,:,1);
T12 = T(:,:,2);
T22 = T(:,:,3);

lambda1 = real( (T11+T22)/2 + sqrt( (T11+T22).^2/4 + T12.^2 - T11.*T22 ) );
lambda2 = real( (T11+T22)/2 - sqrt( (T11+T22).^2/4 + T12.^2 - T11.*T22 ) );

% ê1: (T*ê1 = lambda1*ê1 => ... => e1 = a; e2 = (lambda - T11)/T12;
% || ê1 || = 1 => sqrt(e1^2 + e2^2) = 1 => / e1 = a / => 
% a = 1/sqrt(1+(T12/(lambda1 - T11))^2);
E1e1 = ones(size(T11)) ./ sqrt( 1 + ((lambda1 - T11)./T12 ).^2 );
E1e2 = (lambda1 - T11)./T12.*E1e1;

% ê2:
E2e1 = ones(size(T11)) ./ sqrt( 1 + ((lambda2 - T11)./T12 ).^2 );
E2e2 = (lambda2 - T11)./T12.*E2e1;

% alpha
alpha1 = exp(-lambda1/c);
alpha2 = exp(-lambda2/c);

D11 = alpha1.*E1e1.^2 + alpha2.*E2e1.^2;
D12 = alpha1.*E1e1.*E1e2 + alpha2.*E2e1.*E2e2;
D22 = alpha1.*E1e2.^2 + alpha2.*E2e2.^2;

D = cat(3,D11,D12,D22);
