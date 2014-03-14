function [F] = deblur (f, algo)
%[len angle] = angle_estimatorS(f)
angle  = angle_estimator(f,0)
len = length_estimator(f, angle, 2, 3, 1)
psf = fspecial('motion', len, angle);
nsr = 0.0001;% nsrEstimation(f);

val = zeros(2);
%Lucy Richardson
if algo == 1
 f = edgetaper(f,psf);
%  len =2;
% for i = 1:100
%     len = len+1;
%     psf = fspecial('motion', len, angle);
%     F = deconvlucy(f, psf, 18);
%     Sharpness = bordSobel(F)
%     if val(1)<Sharpness
%         val(1) = Sharpness;
%         val(2) = len;
%     end
% end
% val
   % psf = fspecial('motion', psf, angle);
    F = deconvlucy(f, psf, 18);
end
if algo == 2
    f = edgetaper(f,psf);
    F = deconvwnr(f,psf,nsr);
    F = medfilt2(F);
end
if algo == 3
   % f = edgetaper(f,psf);
    [F arg] = deconvreg(f,psf, nsr);
end

if algo == 4
   % f = edgetaper(f,psf);
    [F P]  = deconvblind(f,psf);
end

end