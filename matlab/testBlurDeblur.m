function [] = testBlurDeblur(algo)
%Test function, 
% -choose a picture to deblur
% -blur it artificially if  not already blurred
% -deblur it 
% -save or show it
% 
% IN : algo speficies the algorithm for deconvolution in the deblur function 

close all;

%%%%%%%%%%%%        Must be blurred         %%%%%%%%%%%%
%cameraman
I = double(imread('cameraman.tif'));

%little girl
%load fille.mat;

%circle
%I = double(imread('circle.png'));

%Moiré pattern
%I = double(imread('Moiré_Pattern.jpg'));
I = double(imread('Moirebricks.jpg'));

%%% Blur the picture
I = blur(I,20,5,2);


%%%%%%%%%%%%        Already blurred         %%%%%%%%%%%%
%Picture on icampus
%I = double(imread('BlurredImageUsed.jpg'));

%Blurred with Gimp function
%I = double(imread('SagarL25A10.jpg'));

%Pictures on internet
%I = double(imread('Car.jpg'));
%I = double(imread('carRed.jpg'));
%I = double(imread('ambulance.jpg'));
%I = double(imread('Aaron.png'));
%I = double(imread('Sea.png'));

% Taken by us
%I = double(imread('IMG_3993.JPG'));
%I = double(imread('computerGray.jpg'));
%I = double(imread('OfficeGray1HD.jpg'));
%I = double(imread('CarGray2HDCrop.png'));


%%%Show the blurred image
save_image(I, 'test', 2);

%%% Deblur the image
deblurred = deblur(I,algo);


%%%Show the deblurred image
save_image(deblurred, 'bricksLanczos',1);
end
