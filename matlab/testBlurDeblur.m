function [] = testBlurDeblur(algo)
%petite fille
%I = load('fille.mat');
%I = I.I;
%save_image(deblur(blur(I,55,60,2)), 'testBlurDeblur',2);

close all;
%Already blurred
%The day we read clearly 485 - PCK please call e immediatly
%I = double(imread('BlurredImageUsed.jpg'));

%Sagar
%I = double(imread('SagarL25A10.jpg'));

% Computer, the professional prog has difficult so ...
%I = double(imread('computerGray.jpg'));

%I = double(imread('Aaron.png'));
%I = double(imread('IMG_3993.JPG'));

%I = double(imread('bordGray.jpg'));

%I = double(imread('Sea.png'));
%To be blurred
%cameraman
I = double(imread('cameraman.tif'));

%Office 
%I = double(imread('OfficeGray1HD.jpg'));

%Car 
%I = double(imread('CarGray2HDCrop.png'));

%petite fille
%I = rgb2gray((imread('filleL50A20.jpg')));
%load fille.mat;



I = blur(I,40,34,2);
save_image(I, 'test', 2);
%I = compression(I);
%save_image(I, 'Blurred',2);
tic
deblurred = deblur(I,algo);
toc
save_image(deblurred, 'Deblurred',2);
%Sharpness = bordSobel(deblurred)


end
