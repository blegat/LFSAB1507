function [F,center] = biggest_square(f, B, debug)
dp = zeros(size(B));
[n, m] = size(B);
if B(1, 1) >= 254
    dp(1,1) = 1;
end
for i = 1:n
    if B(i, 1) >= 254
        dp(i, 1) = 1;
    end
end
for j = 2:m
    if B(1, j) >= 254
        dp(1, j) = 1;
    end
end
for i = 2:n
    for j = 2:m
        if B(i, j) >= 254
            dp(i, j) = 1 + min(dp(i-1,j-1), min(dp(i-1,j),dp(i, j-1)));
        end
    end
end
if debug ==1
save_image(dp*255, 'dp', 2)
end

[origx origy] = max_coord_mat(dp);
orig = [origx, origy];
big = dp(origx, origy);
orig = orig - big + 1; % Move orig from bot/right to top/left

center = round([orig(1) + big / 2 orig(2)+big/2]);
F = f(orig(1):orig(1)+big-1,orig(2):orig(2)+big-1);
end