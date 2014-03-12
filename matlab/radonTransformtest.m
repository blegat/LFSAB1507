function [t] = radonTransformtest(theta)
close all;
load devoir2_image.mat;
len = 40;
%I=double(imread('desertTestL40A70C50.png'));
%I=double(imread('desertTest.png'));
%I=double(imread('Sagar.jpg'));
%I=double(imread('cameraman.tif'));
%I=double(imread('guy.jpg'));
%f=double(imread('SagarL30A30.jpg'));
f = blur(I, len, theta,2);
%h = fspecial('motion', len, theta)
%f = imfilter(I,h,'replicate');
save_image(f,'MotionBlur',2);
figure
size(f);

%Id = ones(size(f));
thetas = 0:180;
G = fft2(f);

G = fftshift(G);
rInter = log(abs(G));

t = find_angle(f, rInter, thetas);


%Ii = h\f;
%save_image(Ii,'testouille',2);
%length = length_estimator(imrotate(f,-t))
%length = len;
% noise_mean = 0;
% noise_var = 0.0001;
% blurred_noisy = imnoise(f, 'gaussian', ...
%                         noise_mean, noise_var);
% estimated_nsr = noise_var / var(I(:));
% PSF=fspecial('motion',length, t);
% wnr3 = deconvwnr(blurred_noisy, PSF, estimated_nsr);
% save_image(wnr3,'MotionDeblurred',2);
end

function [t] = find_angle(f, rInter, thetas)
R = radon2(rInter,thetas);%, sqrt(2)/2*nm);
[A,xp] = radon(f,thetas);
% IdRad = radon(Id, thetas);
% RDiv = zeros(size(R));
% for i = 1:size(R,1)
%     for j = 1:size(R,2)
%         if IdRad(i,j) ~= 0
%             RDiv(i,j) = R(i,j)/IdRad(i,j);
%         end
%     end
% end

%plot(xp, R)

mid_elemt=round(size(R,1)/2);
mid_size=floor(min(size(f))/4*sqrt(2))-1;
R=R(mid_elemt-mid_size:mid_elemt+mid_size,:);

figure
plot(thetas,var(R));
title('Var de la transfo de Radon');

[m i] = max(var(R));

t = thetas(i);

%t = atand(t/atand(size(f,2)/size(f,1)));
% leg = cell(numel(thetas),1);
% for i = 1:numel(thetas)
%     leg{i} = num2str(thetas(i));
% end
% legend(leg);

end
