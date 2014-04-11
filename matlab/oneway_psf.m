function [psf] = oneway_psf(len, angle)
midway_psf = fspecial('motion', len, angle);
angle = mod(angle + 180, 360)
[n m] = size(midway_psf);
if angle > 270 || angle < 90
    inty = m:2*m-1;
else
    inty = 1:m;
end
if angle > 0 && angle < 180
    intx = 1:n;
else
    intx = n:2*n-1;
end
psf = zeros(n*2-1, m*2-1);
psf(intx, inty) = midway_psf;
%centered_psf_hat = centered_psf(end:-1:1,end:-1:1);
end