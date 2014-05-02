function [ nsr ] = nsrEstimation( f , psf)
%NOISEESTIMATION Summary of this function goes here
%   Detailed explanation goes here
if true
    d = size(f);
    FchangedCenter = f(d(1)/2-round(d(1)/20):d(1)/2+round(d(1)/20),...
        d(2)/2-round(d(2)/20):d(2)/2+round(d(2)/20));
    FchangedCorner1 = f(1:2*round(d(1)/20)+1,...
        1:2*round(d(2)/20)+1);
    FchangedCorner2 = f(1:2*round(d(1)/20)+1,...
        d(2)-2*round(d(2)/20):d(2));
    FchangedCorner3 = f(d(1)-2*round(d(1)/20):d(1),...
        d(2)-2*round(d(2)/20):d(2));
    FchangedCorner4 = f(d(1)-2*round(d(1)/20):d(1),...
        1:2*round(d(2)/20)+1);
       
    
    if(var(FchangedCenter(:))<var(FchangedCorner1(:)))
        Fchanged = FchangedCenter;
    else
        Fchanged = FchangedCorner1;
    end
    if(var(Fchanged(:))>var(FchangedCorner2(:)))
        Fchanged = FchangedCorner2;
    end
    if(var(Fchanged(:))>var(FchangedCorner3(:)))
        Fchanged = FchangedCorner3;
    end
    if(var(Fchanged(:))>var(FchangedCorner3(:)))
        Fchanged = FchangedCorner4;
    end
else
    
    figure()
    BW = roipoly(f/255);
    Fchanged = double(BW);
    %noise = var(dbw(:))
end
noise = var(Fchanged(:));
signal = var(f(:));
nsr = noise/signal;
end

