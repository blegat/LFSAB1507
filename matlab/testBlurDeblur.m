function [ a ] = testBlurDeblur(algo)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


close all;

%Already blurred
%The day we read clearly 485 - PCK please call e immediatly
%I = double(imread('BlurredImageUsedGray.jpg'));

%Sagar
%I = double(imread('SagarL25A10.jpg'));

% Computer, the professional prog has difficult so ...
I = double(imread('computerGray.jpg'));

%To be blurred
%cameraman
%I = double(imread('cameraman.tif'));

%petite fille
%I = rgb2gray((imread('filleL50A20.jpg')));
%load fille.mat;

I = blur(I,50,20,2);
%deblurred = zeros(size(I,1),size(I,2),size(I,3));
%  for i = 1:3
%  deblurred(:,:,i) = deblur(I(:,:,i),algo);
%  end

save_image(I, 'Blurred',2);
deblurred = deblur(I,algo);
Sharpness = bordSobel(deblurred)
save_image(deblurred, 'Deblurred',2);

end

