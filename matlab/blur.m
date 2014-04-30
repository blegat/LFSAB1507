function [f] = blur(I, len, angle, meth)
% BLUR is used to artificially blur a picture 
% with an angle (angle) and a length (len) given
% IN :	I the image
% 		len the length of the motion blur
%		angle the angle of the motion blur
%		meth the method used to blur 
%OUT : 	f the blurred picture		

%If you don't want to blur we don't blur
if len == 0 && angle == 0
    f = I;
    return
end
%If no method specified, we use the oneway_psf 
%function to create the psf
if nargin < 4
    meth = 2;
end
%blur with conv2c
if meth == 1
    f = conv2c(I, motion(len, angle));
%blur with fspecial to create the psf and imfilter to blur    
elseif meth == 2
    %h = fspecial('motion', len, angle);
    h = oneway_psf(len,angle);
    f = imfilter(I,h,'circular');
%oneway_psf function to create the psf and imfilter to blur
elseif meth == 3
    h = oneway_psf(len, angle);
    f = imfilter(I, h);
else 
    h = fspecial('motion', len, angle);
    f = imfilter(I, h);    
end
