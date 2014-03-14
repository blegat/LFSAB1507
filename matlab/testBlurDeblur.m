function [ output_args ] = testBlurDeblur(algo)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%petite fille
%load fille.mat
%save_image(deblur(blur(I,55,60,2)), 'testBlurDeblur',2);


close all;
%The day we read clearly 485 - PCK please call e immediatly
%I = double(imread('BlurredImageUsedGray.jpg'));

%Sagar
I = double(imread('SagarL25A10.jpg'));

%I = double(imread('computerGray.jpg'));
%I = double(imread('cameraman.tif'));
%deblurred = zeros(size(I,1),size(I,2),size(I,3));
%  for i = 1:3
%  deblurred(:,:,i) = deblur(I(:,:,i),algo);
%  end
%I = blur(I,20,20,1);
save_image(I, 'Blurred',2);
deblurred = deblur(I,algo);
%Sharpness = bordSobel(deblurred)
save_image(deblurred, 'Deblurred',2);

end

