function [] = spec_show(I)
G = fftshift(fft2(I));
[n m] = size(G);
[x y] = meshgrid(linspace(0,1,m), linspace(0,1,n));
figure
size(x)
size(y)
size(G)
contourf(x, y, log(abs(G)), -10:1:10);
figure
surf(x, y, log(abs(G)));
end