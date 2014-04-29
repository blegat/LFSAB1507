function [] = testBlurDeblur(test, algo, len, blur_angle, blur_meth, iter)
%Test function, 
% -choose a picture to deblur
% -blur it artificially if  not already blurred
% -deblur it 
% -save or show it
% 
% IN : algo speficies the algorithm for deconvolution in the deblur function 

global test_name;
global L;
global angle;
global blur_method;

if nargin < 5
    blur_meth = 2;
    iter = 16;
end

close all;

k_len = 2;
%%%%%%%%%%%%        Must be blurred         %%%%%%%%%%%%
if test == 1
    %cameraman
    I = double(imread('cameraman.tif'));
    test_name = 'cameraman';
elseif test == 3
    %little girl
    load fille.mat;
    test_name = 'girl';
elseif test == 5
    %circle
    I = double(imread('circle.png'));
    test_name = 'circle';
elseif test == 7
    %Moire pattern
    I = double(imread('Moire_Pattern.jpg'));
    test_name = 'pattern';
elseif test == 9
    I = double(imread('../Images/bricks.jpg'));
    test_name = 'bricks';
end

%%% Blur the picture
if mod(test,2) == 1
<<<<<<< HEAD
 %   I = blur(I,len,blur_angle,2);
=======
    I = blur(I,len,blur_angle,blur_meth);
>>>>>>> a94995541b65f40d536f851710dd87c7b08576f1
    L = len;
    angle = blur_angle;
    if blur_meth == 2
        blur_method = 'circ';
    else
        blur_method = 'black';
    end
end


%%%%%%%%%%%%        Already blurred         %%%%%%%%%%%%
if test == 2
    %Picture on icampus
    I = double(imread('BlurredImageUsed.jpg'));
    test_name = 'plaque';
elseif test == 4
    %Blurred with Gimp function
    I = double(imread('SagarL25A10.jpg'));
    test_name = 'sagar'; % (25, 171)
    k_len = 3;
elseif test == 6
    %Pictures on internet
    %I = double(imread('Car.jpg'));
    %I = double(imread('carRed.jpg'));
    %I = double(imread('ambulance.jpg'));
    I = double(imread('Aaron.png'));
    test_name = 'aaron';
    %I = double(imread('Sea.png'));
elseif test == 8
    % Taken by us
    %I = double(imread('IMG_3993.JPG'));
    %I = double(imread('computerGray.jpg'));
    %I = double(imread('OfficeGray1HD.jpg'));
    %I = double(imread('CarGray2HDCrop.png'));
end


%%%Show the blurred image
save_image(I, 'g', 2);

%%% Deblur the image


deblurred = deblur(I,algo,0,k_len,iter);


%%%Show the deblurred image
    save_image(deblurred, 'bricksLanczos', 1);
end
