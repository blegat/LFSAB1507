function [] = cam()

bg = double(rgb2gray(imread('stv_bg.jpg')));
I = double(rgb2gray(imread('stv_blur1.jpg')));
save_image(I, 'blu', 2);
save_image(abs(I - bg), 'dif', 2);

var = 2;

dif = abs(I - bg);
%dif(dif > var) = 255;
%save_image(dif, 'dif', 2);
[n m] = size(I);

dif = filter_block(dif, 10, 100);

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