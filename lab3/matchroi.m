function M = matchroi(rl1,rl2)%,r1,r2,c1,c2,lambda)

M = inf(size(rl1,2),size(rl2,2));   

for patch1 = 1:size(rl1,2)
   for patch2 = 1:size(rl2,2)
        e = norm(rl1(:,patch1) - rl2(:,patch2));
       % d = norm([c1(patch1);r1(patch1)] - [c2(patch2);r2(patch2)]);
        M(patch1,patch2) = e;%+lambda*d;
   end
end
end