function [F] = deblur_cam(f, algo, B, dif, bg, debug)
angle  = robust_angle_estimator(f, 0, B)

[fs center] = biggest_square(f(:,:,1), B, debug);
% w_hann1 = hann(size(fs,1));
% w_hann2 = w_hann1(:)*w_hann1(:).';
% fs = w_hann2 .* fs;
len = length_estimator(fs, angle, 2, 5, 0)

[connected minx maxx miny maxy] = flood_fill(center, B);

focusx = max(minx-len,1):min(maxx+len,size(connected,1));
focusy = max(miny-len,1):min(maxy+len,size(connected,2));

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
psf = oneway_psf(len, angle);
tic
for i=1:iterColorOrGray
    if algo == 1
        index_fg = find(focus_connected==1);
        F(focusx,focusy,i) = lucy(focus_f(:,:,i), psf, len, angle, 10, 0, 2, index_fg); % Method 2
    elseif algo == 2
        subfocus = lucy(focus_f(:,:,i), psf, len, angle, 4, 1, 4, focus_dif, focus_bg(:,:,i)); % Method 4
        % subfocus can be smaller that F(focusx,focusy,i) because of the
        % rotations
        dx = numel(focusx) - size(subfocus,1);
        dx2 = floor(dx/2);
        subfocusx = focusx(1)+dx2:focusx(end)-dx+dx2;
        dy = numel(focusy) - size(subfocus,2);
        dy2 = floor(dy/2);
        subfocusy = focusy(1)+dy2:focusy(end)-dy+dy2;
        size(subfocus)
        size(subfocusx)
        size(subfocusy)
        F(subfocusx,subfocusy,i) = subfocus;
    else
        % Wiener
        focus_f = edgetaper(focus_f,psf);
        nsr = nsrEstimation(focus_f, psf);
        focus_F = deconvwnr(focus_f,psf,nsr);
        F(focusx,focusy,i) = focus_f(:,:,i) .* (1-focus_connected) + focus_F(:,:,i) .* focus_connected;
    end
end
toc
if debug
    save_image(F,'deb',2);
end

end