function [] = testBlurDeblur(algo)
%petite fille
I = load('fille.mat');
I = I.I;
%save_image(deblur(blur(I,55,60,2)), 'testBlurDeblur',2);

close all;
%Already blurred
%The day we read clearly 485 - PCK please call e immediatly
I = double(imread('BlurredImageUsed.jpg'));

%Sagar
%I = double(imread('SagarL25A10.jpg'));

% Computer, the professional prog has difficult so ...
%I = double(imread('computerGray.jpg'));

<<<<<<< HEAD
%I = double(imread('Aaron.png'));
%I = double(imread('IMG_3923.JPG'));

%I = double(imread('bordGray.jpg'));
=======
%I = double(imread('AaronGray.png'));
I= double(imread('bordGray.jpg'));
>>>>>>> ab952d7e3013c30672678795daa5a7b8ce83b15f
%I = double(imread('SeaGray.png'));
%To be blurred
%cameraman
%I = double(imread('cameraman.tif'));

%Office 
%I = double(imread('OfficeGray2HDCrop.jpg'));

%Car 
%I = double(imread('CarGray2HDCrop.png'));
%petite fille
%I = rgb2gray((imread('filleL50A20.jpg')));
%load fille.mat;

<<<<<<< HEAD
=======
I = blur(I,50,20,1);
%deblurred = zeros(size(I,1),size(I,2),size(I,3));
%  for i = 1:3
%  deblurred(:,:,i) = deblur(I(:,:,i),algo);
%  end
>>>>>>> ab952d7e3013c30672678795daa5a7b8ce83b15f


%I = blur(I,20,20,2);
I = compression(I);
save_image(I, 'Blurred',2);
deblurred = deblur(I,algo);
save_image(deblurred, 'Deblurred',2);
%Sharpness = bordSobel(deblurred)


end
