function [F] = deblur (f)
angle = angle_estimator(f);
len = length_estimator(f, angle);
psf = fspecial('motion', len, angle);
F = lucy(f, psf, 100);
end