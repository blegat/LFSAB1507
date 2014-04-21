function [F] = rotate_crop(f, angle)
[h w] = size(f);
R = imrotate(f, angle);
angle

a = pi * angle / 180;
if angle < 0
    a = -a;
    mid = h * cos(a);
else
    a = pi/2 - a;
    mid = w * cos(a);
end
[H W] = size(R);
x = W/4;
y1 = max(1,ceil(mid-x*cot(a)));
y2 = min(H,floor(mid+x*tan(a)));
F = R(y1:y2, ceil(x):floor(W/2));
end