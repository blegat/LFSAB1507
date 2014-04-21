function [F] = deblur_cam(f, algo, B, dif, bg, debug)
angle  = robust_angle_estimator(f, 0, B)

[fs center] = biggest_square(f(:,:,1), B, debug);
% w_hann1 = hann(size(fs,1));
% w_hann2 = w_hann1(:)*w_hann1(:).';
% fs = w_hann2 .* fs;
len = length_estimator(fs, angle, 2, 5, 0)

[connected minx maxx miny maxy] = flood_fill(center, B);

focusx = minx-len:maxx+len;
focusy = miny-len:maxy+len;

focus_connected = connected(focusx, focusy);
focus_bg = bg(focusx, focusy, :);
focus_dif = dif(focusx, focusy);
focus_B = B(focusx, focusy);
focus_Bdif = B .* dif;
var = 10;
focus_Bdif(focus_Bdif < var) = 0;

if debug
    save_image(255*focus_connected, 'test', 2);
    save_image(10*focus_dif, 'test', 2);
    save_image(10*focus_dif.*focus_connected, 'test', 2);
    save_image(10*focus_Bdif, 'test', 2);
end

fsize = size(f)
if length(fsize) == 2
    iterColorOrGray = 1;
    focus_f = f(focusx, focusy);
else
    iterColorOrGray = 3;
    focus_f = f(focusx, focusy, :);
end

F = f;
%Lucy Richardson
index_fg = find(focus_connected==1);
psf = oneway_psf(len, angle);
tic
for i=1:iterColorOrGray
    if algo == 1
        F(focusx,focusy,i) = lucy(focus_f(:,:,i), psf, len, angle, 10, 0, 2, index_fg); % Method 2
    else
        F(focusx,focusy,i) = lucy(focus_f(:,:,i), psf, len, angle, 4, 0, 4, focus_dif, focus_bg(:,:,i)); % Method 4
    end
end
toc
if debug
    save_image(F,'deb',2);
end

end