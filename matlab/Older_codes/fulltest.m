f = double(imread('cameraman.tif'));
fh = blur(f, 30, 30);
save_image(fh, 'blur', 2);
fhat = deblur(fh);
save_image(fhat, 'deblur', 2);