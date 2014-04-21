function [] = testCam (algo)
% testBlurDeblur for cam
close all;
%bg = double(rgb2gray(imread('stv_bg.jpg')));
%I = double(rgb2gray(imread('stv_blur1.jpg')));

%Stivy
bg = double(imread('stv_bg.jpg'));
fg = double(imread('stv_blur1.jpg'));

%Arnaud Up
%bg = double(imread('bgArUp.JPG'));
%I = double(imread('ArUp.JPG'));
save_image(fg, 'blu', 2);

%save_image(abs(I - bg), 'dif', 2);
F = cam(fg, bg, algo);
save_image(F, 'deblu', 2);
end