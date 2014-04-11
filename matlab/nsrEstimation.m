function [ nsr ] = nsrEstimation( f )
%NOISEESTIMATION Summary of this function goes here
%   Detailed explanation goes here

BW = roipoly(f/255);
dbw = double(BW);
noise = var(dbw(:))
signal = var(f(:))
nsr = 10*log(noise/signal)

end

