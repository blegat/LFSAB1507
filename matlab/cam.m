function [F] = cam(fg, bg, algo)
dif = abs(fg(:,:,1) - bg(:,:,1));
B = dif;

var = 8;
%var = graythresh(dif)
%dif = im2bw(dif, var) * 255;
B(B < var) = 0;
B(B > var) = 255;
%save_image(dif, 'dif', 2);

var = 128;
n = 5;
while var > 4
    B = shapeit(B, var, n);
    %save_image(dif, 'dif', 2);
    var = var / 2;
end

%B = biggest_square(I(:,:,1), dif, debug);
%save_image(B, 'blurred', 2);

% angle  = robust_angle_estimator(I, 0, dif)
% len = length_estimator(B, angle, 2, 5, 0)
% psf = fspecial('motion', len, angle);
% F = lucy(B, psf, 18);

%save_image(dif*10,'test', 2);
%save_image(B,'test', 2);
%save_image(B.*dif,'test', 2)
F = deblur_cam(fg, algo, B, dif, bg, 0);
%save_image(F, 'deblurred', 2);

end


function [D] = shapeit(dif, var, n)
h = fspecial('gaussian', [n n], 2);
%h = fspecial('average', n);
dif = imfilter(dif,h,'circular');
dif(dif < var) = 0;
dif(dif > var) = 255;
D = dif;
end

function [B] = filter_block(A, decal, threshold)
% remove alone
presum = A;
[n m] = size(A);
for i = 1:n
    if i > 1
        presum(i, 1) = A(i, 1) + presum(i-1, 1);
    else
        presum(1, 1) = A(1, 1);
    end
    for j = 2:m
        if i > 1
            presum(i, j) = A(i, j) + presum(i-1, j) + presum(i, j-1) - presum(i-1,j-1);
        else
            presum(1, j) = presum(1, j-1) + A(1, j);
        end
    end
end
[r, c] = find(dif > var);
difn = dif;
% for i = 1:numel(r)
%     square = dif(decale(r(i),-decal,n):decale(r(i),decal,n),...
%                  decale(c(i),-decal,m):decale(c(i),decal,m));
%     mu = mean(mean(square));
%     if mu * dif(r(i), c(i)) < threshold
%         dif(r(i), c(i)) = 0;
%     else
%         dif(r(i), c(i)) = 255;
%     end
%     difn(r(i), c(i)) = 255;
% end
for i = 1:n
    for j = 1:m
        square = dif(decale(i,-decal,n):decale(i,decal,n),...
            decale(j,-decal,m):decale(j,decal,m));
        mu = mean(mean(square));
        if mu * dif(i, j) < threshold
            dif(i, j) = 0;
        else
            dif(i, j) = 255;
        end
        if dif(i, j) < threshold
            difn(i, j) = 255;
        end
    end
end

save_image(difn, 'dif', 2);
save_image(dif, 'dif', 2);

end

function [j] = decale (i, d, len)
j = min(len, max(1, i + d));
end
