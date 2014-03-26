function [] = cam()

bg = double(rgb2gray(imread('stv_bg.jpg')));
I = double(rgb2gray(imread('stv_blur1.jpg')));
save_image(I, 'blu', 2);
save_image(abs(I - bg), 'dif', 2);

dif = abs(I - bg);

var = 8
%var = graythresh(dif)
%dif = im2bw(dif, var) * 255;
dif(dif < var) = 0;
dif(dif > var) = 255;
save_image(dif, 'dif', 2);

var = 128;
n = 8;
while var > 4
    dif = shapeit(dif, var, n);
    save_image(dif, 'dif', 2);
    var = var / 2;
end

[orig, big] = biggest_square(dif);
orig

B = I(orig(1):orig(1)+big-1,orig(2):orig(2)+big-1);
save_image(B, 'blurred', 2);

end


function [D] = shapeit(dif, var, n)
h = fspecial('gaussian', [n n], 2);
%h = fspecial('average', n);
dif = imfilter(dif,h,'circular');
dif(dif < var) = 0;
dif(dif > var) = 255;
D = dif;
end

function [orig, big] = biggest_square (A)
dp = zeros(size(A));
[n, m] = size(A);
if A(1, 1) >= 254
    dp(1,1) = 1;
end
for i = 1:n
    if A(i, 1) >= 254
        dp(i, 1) = 1;
    end
end
for j = 2:m
    if A(1, j) >= 254
        dp(1, j) = 1;
    end
end
for i = 2:n
    for j = 2:m
        if A(i, j) >= 254
            dp(i, j) = 1 + min(dp(i-1,j-1), min(dp(i-1,j),dp(i, j-1)));
        end
    end
end

save_image(dp*255, 'dp', 2)

[origx origy] = max_coord_mat(dp);
orig = [origx, origy]
big = dp(origx, origy)
orig = orig - big + 1 % Move orig from bot/right to top/left
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