function [f] = blur_cam(I, bg, len, angle)
mask = I;
mask(mask > 0) = 1;
mask(mask <= 0) = 0;
mask = blur(mask,len,angle,3);
I = blur(I, len, angle, 3);
f = I + (1-mask) .* bg;
end