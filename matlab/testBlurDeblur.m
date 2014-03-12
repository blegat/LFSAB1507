function [ output_args ] = testBlurDeblur(algo)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%petite fille
load fille.mat
%save_image(deblur(blur(I,55,60,2)), 'testBlurDeblur',2);


close all;
%Plaque d'immatriculation
%I = double(imread('BlurredImageUsedGray.jpg'));
%I = double(imread('cameraman.tif'));
%I = double(imread('cameraman.tif'));
%deblurred = zeros(size(I,1),size(I,2),size(I,3));
%  for i = 1:3
%  deblurred(:,:,i) = deblur(I(:,:,i),algo);
%  end
I = blur(I,20,20,1);
deblurred = deblur(I,algo);
bordSobel(deblurred)
save_image(deblurred, 'testBlurDeblur',2);

end

