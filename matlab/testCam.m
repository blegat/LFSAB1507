function [] = testCam (len, blur_angle, test, algo, iter)
% testBlurDeblur for cam

global test_name;
global L;
global angle;
global blur_method;

close all;
mix = 0;
if test == 1
    %bg = double(rgb2gray(imread('stv_bg.jpg')));
    %I = double(rgb2gray(imread('stv_blur1.jpg')));
    %Stivy
    bg = double(imread('stv_bg.jpg'));
    fg = double(imread('stv_blur2.jpg'));
    test_name = 'car';
elseif test == 2
    bg = double(imread('Back.bmp'));
%A = double(imread('Sub.bmp'));
%D = abs(A - bg);
    sub = double(imread('h2g2_blue.jpg'));
    test_name = 'dontpanic_blue';
    mix = 1;
elseif test == 3
    bg = double(imread('Back.bmp'));
    fg = double(imread('Blur100-0.bmp'));
elseif test == 4
    n = 100;
    bg = ones(n, n)*10;
    sub = ones(51,51)*200;
    test_name = 'square';
    mix = 1;
end
if mix
    [N M k] = size(bg);
    [n m k] = size(sub);
    a = floor((N-n)/2);
    b = floor((M-m)/2);
    intx = a:a+n-1;
    inty = b:b+m-1;
    fg = bg * 0;
    fg(intx,inty,:) = sub;
    fg = blur_cam(fg, bg, len, blur_angle);

    L = len;
    angle = blur_angle;
end

%bg = double(imread('01.jpg'));
%fg = double(imread('11.jpg'));

%Arnaud Up
%bg = double(imread('bgArUp.JPG'));
%I = double(imread('ArUp.JPG'));
%save_image(fg, 'blu', 2);
%blurr = sprintf('%s-%d_%d', name, len, blur_angle);
%deblu = sprintf('%s-%d_%d-%d_%d-%d', name, len, blur_angle, test, algo, iter);
save_image(fg, 'g', 2);
F = cam(fg, bg, algo, iter, 0);
save_image(F, 'f', 2);
end