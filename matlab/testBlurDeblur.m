function [] = testBlurDeblur(algo)
%petite fille
I = load('fille.mat');
I = I.I;
%save_image(deblur(blur(I,55,60,2)), 'testBlurDeblur',2);

close all;
%Already blurred
%The day we read clearly 485 - PCK please call e immediatly
%I = double(imread('BlurredImageUsedGray.jpg'));

%Sagar
%I = double(imread('SagarL25A10.jpg'));

% Computer, the professional prog has difficult so ...
%I = double(imread('computerGray.jpg'));

%I = double(imread('AaronGray.png'));
I= double(imread('bordGray.jpg'));
%I = double(imread('SeaGray.png'));
%To be blurred
%cameraman
%I = double(imread('cameraman.tif'));

%petite fille
%I = rgb2gray((imread('filleL50A20.jpg')));
%load fille.mat;

I = blur(I,50,20,1);
%deblurred = zeros(size(I,1),size(I,2),size(I,3));
%  for i = 1:3
%  deblurred(:,:,i) = deblur(I(:,:,i),algo);
%  end

save_image(I, 'Blurred',2);
deblurred = deblur(I,algo);
save_image(deblurred, 'Deblurred',2);
%Sharpness = bordSobel(deblurred)


end
