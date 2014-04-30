function [F] = deblur_cam(f, algo, iter, B, dif, bg, comp, debug)
[ratio partfForPSF] = compression(f,comp);
[ratio partBForPSF] = compression(B,comp);
angle = 0%robust_angle_estimator(partfForPSF, 0, partBForPSF)

[fs center] = biggest_square(f(:,:,1), B, debug);
% w_hann1 = hann(size(fs,1));
% w_hann2 = w_hann1(:)*w_hann1(:).';
% fs = w_hann2 .* fs;
% TODO: small for small images
len = length_estimator(fs, angle, 2, 5, 0)

[connected minx maxx miny maxy] = flood_fill(center, B);

focusx = max(minx-2*len,1):min(maxx+2*len,size(connected,1));
focusy = max(miny-2*len,1):min(maxy+2*len,size(connected,2));

focus_connected = connected(focusx, focusy);
focus_bg = bg(focusx, focusy, :);
focus_dif = dif(focusx, focusy);
focus_B = B(focusx, focusy);
focus_Bdif = B .* dif;
var = 10;
focus_Bdif(focus_Bdif < var) = 0;

if debug
    save_image(255*focus_connected, 'connected', 2);
    save_image(10*focus_dif, 'focusdiff', 2);
    save_image(10*focus_dif.*focus_connected, 'focusdiffconnected', 2);
    save_image(10*focus_Bdif, 'focus_Bdif', 2);
end

fsize = size(f)
if length(fsize) == 2
    iterColorOrGray = 1;
    focus_f = f(focusx, focusy);
else
    iterColorOrGray = 3;
    focus_f = f(focusx, focusy, :);
end

%F = f;
[ratio F] = compression(f,2*comp);
%Lucy Richardson
lenCompressed = ratio*len;
psf = oneway_psf(lenCompressed, angle);
tic
for i=1:iterColorOrGray
    if algo == 1
        index_fg = find(focus_connected==1);
        F(focusx,focusy,i) = lucy(focus_f(:,:,i), psf, len, angle, iter, 0, 2, index_fg); % Method 2
    elseif algo == 2
        subfocus = lucy(focus_f(:,:,i), psf, len, angle, iter, 0, 4, focus_dif, focus_bg(:,:,i)); % Method 4
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