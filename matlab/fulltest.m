f = im2double(imread('cameraman.tif'));
blur(f, 30, 30);
F = deblur(f);
imshow(F);