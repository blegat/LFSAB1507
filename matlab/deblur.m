function [F] = deblur (f, algo, B)
%[len angle] = angle_estimatorS(f);
B = 255*ones(size(f(:,:,1)));
angle  = robust_angle_estimator(f, 0, B)
len = length_estimator(f, angle, 2, 5, 0)
psf = fspecial('motion', len, angle);
%save_image(f, 'Blur',2);
nsr = 0.001;%nsrEstimation(f);
fsize = size(f);
if length(fsize) == 2
    iterColorOrGray = 1;
else
    iterColorOrGray = 3;
end
val = zeros(2);
F = zeros(size(f));
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
   for i=1:iterColorOrGray
    F(:,:,i) = lucy(f(:,:,i), psf, 18);
   F(:,:,i) = wiener2(F(:,:,i), [5 5]);
   end
   %imshow(F/255);
    save_image(F,'deb',2);
%  F = medfilt2(F);
    
       
end
if algo == 2
   f = edgetaper(f,psf);
    F = deconvwnr(f,psf,nsr);
    save_image(F,'deb',2);
    F = wiener2(F, [5 5]);
    %F = medfilt2(F);
  
end
if algo == 3
   f = edgetaper(f,psf);
    [F arg] = deconvreg(f,psf, nsr);
      save_image(F,'deb',2);
    F = wiener2(F, [2 2]);
    save_image(F,'wi',2);
  F = medfilt2(F);
 
end

if algo == 4
   % f = edgetaper(f,psf);
    [F P]  = deconvblind(f,psf);
end

end
