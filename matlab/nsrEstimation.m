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

if true
    d = size(f);
    FchangedCenter = f(d(1)/2-round(d/20):d(1)/2+round(d/20),d(2)/2-round(d/20):d(2)/2+round(d/20));
    FchangedCorner = f(1:2*round(d/20)+1,1:2*round(d/20)+1);
    if(var(FchangedCenter(:))<var(FchangedCorner(:)))
        Fchanged = FchangedCenter/255;
    else
        Fchanged = FchangedCorner/255;
    end
else
    
    figure()
    BW = roipoly(f/255);
    Fchanged = double(BW);
    %noise = var(dbw(:))
end
noise = var(Fchanged(:))
signal = var(f(:)/255)
nsr = noise/signal
end

