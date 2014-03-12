function [F] = deblur (f, algo)
angle = 20;%angle_estimator(f)
len = length_estimator(f, angle, 2, 10, 0)
psf = fspecial('motion', len, angle);
snr = 0.2;

%Lucy Richardson
if algo == 1
 %f = edgetaper(f,psf);
%     for i = 1:3
%         F(:,:,i) = lucy(f(:,:,i), psf, 100);
%     end
     F = lucy(f, psf, 30);
end
if algo == 2
   % f = edgetaper(f,psf);
    F = deconvwnr(f,psf,snr);
end
if algo == 3
   % f = edgetaper(f,psf);
    [F arg] = deconvreg(f,psf,snr);
end

end