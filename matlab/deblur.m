function [F] = deblur (f, algo)
angle =angle_estimator(f)
len = 60; %length_estimator(f, angle, 2, 3, 1)
psf = fspecial('motion', len, angle);
nsr = 0;

%Lucy Richardson
if algo == 1
 f = edgetaper(f,psf);
%     for i = 1:3
%         F(:,:,i) = lucy(f(:,:,i), psf, 100);
%     end
     F = lucy(f, psf, 30);
end
if algo == 2
    f = edgetaper(f,psf);
    F = deconvwnr(f,psf,nsr);
end
if algo == 3
    f = edgetaper(f,psf);
    [F arg] = deconvreg(f,psf,nsr);
end

end