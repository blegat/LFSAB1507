function [ nsr ] = nsrEstimation( f , psf)
%NOISEESTIMATION Summary of this function goes here
%   Detailed explanation goes here
if false
    uniform_quantization_var = (1/256)^2 / 12;
    I = im2double(imread('cameraman.tif'));
    signal_var = var(I(:))
    uniform_quantization_var / signal_var
    wnr5 = deconvwnr(f, psf, ...
        uniform_quantization_var / signal_var);
    figure(10)
    title('Restoration of Blurred, Quantized Image Using Computed NSR');
    imshow(wnr5)
    
    
end
figure()
BW = roipoly(f/255);
dbw = double(BW);
noise = var(dbw(:))
signal = var(f(:))
nsr = noise/signal
end

