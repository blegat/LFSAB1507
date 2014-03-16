function [f] = blur(I, len, angle, meth)
if nargin < 4
    meth = 1;
end
if meth == 1
    f = conv2c(I, motion(len, angle));
   % save_image(f,'blurred',2);
else
    h = fspecial('motion', len, angle);
    f = imfilter(I,h,'replicate');
    
end