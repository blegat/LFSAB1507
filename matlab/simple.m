load fille;
n = size(I,1);
m = size(I,2);
k = 6;
psf = ones(1,k) / k;
A = spdiags(ones(n,k) / k, -k+1:0, n, n);
B = spdiags(ones(m,k) / k, -k+1:0, m, m)';
H = kron(B', A);
save = 1; % 1: save, 2: just show
tester(I, psf, A, @(img) img, 'nonoise',save);
tester(I, psf, A, @(img) imnoise(img/255, 'gaussian',0,0.001)*255, 'noise-g10',save);
tester(I, psf, A, @(img) imnoise(img/255, 'poisson')*255, 'noise-poisson',save);
