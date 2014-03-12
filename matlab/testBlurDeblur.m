function [ output_args ] = testBlurDeblur(algo)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%petite fille
%load fille.mat
%save_image(deblur(blur(I,55,60,2)), 'testBlurDeblur',2);

%Plaque d'immatriculation
close all;
%I = double(imread('BlurredImageUsed.jpg'));
I = double(imread('cameraman.tif'));
%deblurred = zeros(size(I,1),size(I,2),size(I,3));
%  for i = 1:3
%  deblurred(:,:,i) = deblur(I(:,:,i),algo);
%  end
I = blur(I,60,60,1);
deblurred = deblur(I,algo);
bordSobel(deblurred)
save_image(deblurred, 'testBlurDeblur',2);

end

