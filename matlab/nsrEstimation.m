function [ nsr ] = nsrEstimation( f )
%NOISEESTIMATION Summary of this function goes here
%   Detailed explanation goes here

BW = roipoly(f);
dbw = double(BW);
noise = var(dbw(:))
signal = var(f(:))
nsr = noise/signal

end

