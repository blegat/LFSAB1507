function H = build_H (k, m)
H = spdiags(ones(m,k) / k, -k+1:0, m, m);
for j = 1:k-1
    H(j,1) = (k-j+1)/k;
end