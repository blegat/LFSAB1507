function [length] = cepstraltest (len, meth, k, dbg)
close all;
theta = 0;
%load fille;
I = double(imread('cameraman.tif'));
%I = double(imread('guy.jpg'));
%h = fspecial('motion', len, 0, 2);
f = blur(I, len, theta);
%f = imfilter(I,h,'replicate');
if dbg
    save_image(f,'MotionBlur',2);
end

%c = fftshift(ifft(ifftshift(log(abs(fftshift(fft(h)))))));
%c = fftshift(ifft2(ifftshift(log(abs(fftshift(fft2(f)))))));
c = log(fftshift(fft2(abs(log(abs(fftshift(fft2(f))))))));
%plot(linspace(0,1,numel(c)), c);

[cx cy] = max_coord_mat(c);

if meth == 1
    length = peek_finder_1(real(c(cx,:)), cy, k, k) - cy;
else
    length = peek_finder_2(real(c(cx,:)), cy, k) - cy;
end

if dbg
    [n m] = size(c);
    figure
    plot(1:n, real(c(cx,:)));
    [N, M] = meshgrid(1:m, 1:n);
    size(N)
    size(c)
    
    figure
    surf(N, M, real(c));
end

end

% Not good for length < 2*k
function [peek] = peek_finder_1(array, center, k1, k2)
peek = center; % If none is found, no blur :)
for cur = center+1:numel(array)-k2
    [m, ind] = max(array(cur-k1:cur+k2));
    if ind == k1+1
        peek = cur;
        break;
    end
end
end

% Here smaller k works but not good for length < 2*k still
function [peek] = peek_finder_2(array, center, k)
end_of_center = peek_finder_1(array, center, k, 0)
[m peek] = max(array(end_of_center:end));
peek = peek + end_of_center - 1;
end

function [x, y] =  max_coord_mat (A)
[max_in_col, ind_in_col] = max(A);
[max_max, ind_col] = max(max_in_col);
y = ind_col;
x = ind_in_col(ind_col);
end
