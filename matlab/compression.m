function [ F ] = compression( I )
%COMPRESSION Compress a picture

%Idct = dct(I);
%plothot(Idct);
d = size(I);
ratio = 1;
if max(d(1),d(2)) > 1000
ratio = 705/max(d(1),d(2));
end
F = imresize(I,ratio);
end

