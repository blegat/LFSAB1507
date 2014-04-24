function [] = testCam (test, algo)
% testBlurDeblur for cam
close all;
if test == 1
    %bg = double(rgb2gray(imread('stv_bg.jpg')));
    %I = double(rgb2gray(imread('stv_blur1.jpg')));
    %Stivy
    bg = double(imread('stv_bg.jpg'));
    fg = double(imread('stv_blur1.jpg'));
elseif test == 2
    bg = double(imread('Back.bmp'));
%A = double(imread('Sub.bmp'));
%D = abs(A - bg);
    sub = double(imread('h2g2.jpg'));
    save_image(bg, 'bg', 2);
    save_image(sub, 'sub', 2);
    [N M k] = size(bg)
    [n m k] = size(sub)
    a = floor((N-n)/2);
    b = floor((M-m)/2);
    intx = a:a+n-1;
    inty = b:b+m-1;
    fg = bg * 0;
    fg(intx,inty,:) = sub;
    save_image(fg, 'fg', 2);
    fg = blur_cam(fg, bg, 40, 0);
    save_image(fg, 'fgb', 2);
elseif test == 3
    bg = double(imread('Back.bmp'));
    fg = double(imread('Blur100-0.bmp'));
elseif test == 4
    n = 100;
    a = n/4;
    b = 3*n/4;
    bg = ones(n, n)*10;
    ratio = zeros(n,n);
    ratio(a:b,a:b) = 1;
    save_image(100*ratio,'sol', 2);
    ratio = blur(ratio,10,0,3);
    %figure
    %imshow(ratio);
    %figure
    %imshow(bg);
    save_image(ratio, 'ratio', 2);
    save_image(ratio * 100, 'deblurme', 2);
    fg = bg .* (1-ratio) + ratio .* 100;
end

%bg = double(imread('01.jpg'));
%fg = double(imread('11.jpg'));

%Arnaud Up
%bg = double(imread('bgArUp.JPG'));
%I = double(imread('ArUp.JPG'));
%save_image(fg, 'blu', 2);

save_image(abs(fg - bg), 'dif', 2);
F = cam(fg, bg, algo, 0);
save_image(F, 'deblu', 2);
end