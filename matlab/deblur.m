function [F] = deblur (f, algo, comp)
% Deblur the picture given in argument by evaluation of the psf and then 
% deconvolution using lucy, wiener or regularisation
%
% IN :  -f the function which need to be deblurred
%       -algo specifies the algorithm for deconvolution
%           1: Lucy-Richardson
%           2: Wiener
%           3: Regularization
% OUT:  -F the deblurred image


% select part of the picture for qucicker psf estimation
[ratio partfForPSF] = compression(f,comp);

%compute the estimation of the angle of PSF
angle  = robust_angle_estimator(partfForPSF, 0)
%angle = angle_estimator_Gabor(f)

%compute the estimation of the length of PSF
len = length_estimator(partfForPSF, angle, 2, 5, 0)

% Reduce the number of pixels to a defined size if the picture 
% is too big
tic
[ratio f] = compression(f,2*comp);
toc
% Adapt the number of pixels invovled after compression
lenCompressed = ratio*len

%Create the psf with the arguments computed
psf = fspecial('motion', lenCompressed, angle);

%Estimate the noise to signal ratio to have a better wiener or
%regularization deconvolution
nsr = nsrEstimation(f, psf);

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
 %f = edgetaper(f,psf);
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
   tic
   for i=1:iterColorOrGray
      f(:,:,i) = edgetaper(f(:,:,i),psf);
      F(:,:,i) = deconvlucy(f(:,:,i), psf, 15);
   %  F(:,:,i) = lucy(f(:,:,i), psf, len, angle, 25, 0, 3);
   %  F(:,:,i) = wiener2(F(:,:,i), [5 5]);
   end
   toc
   %imshow(F/255);
  %  save_image(F,'deb',2);
%  F = medfilt2(F);
    
       
end
if algo == 2
   f = edgetaper(f,psf);
  F = deconvwnr(f,psf,nsr);
  
   psf_abs = abs(psf);
  figure()
  %plot(fftshift(psf_abs));
 % fftshift(psf_abs)
  surf(fftshift(psf_abs))
shading interp, camlight, colormap jet
xlabel('PSF FFT magnitude')
  % save_image(F,'deb',2);
    %F = wiener2(F, [5 5]);
    %F = medfilt2(F);
  % F = f;
  
end
if algo == 3
   f = edgetaper(f,psf);
   [F arg] = deconvreg(f,psf,nsr);

  %save_image(F,'deb',2);
  %F = wiener2(F, [2 2]);
  %save_image(F,'wi',2);
  %F = medfilt2(F);
 
end

if algo == 4
   % f = edgetaper(f,psf);
    [F P]  = deconvblind(f,psf);
end

end
