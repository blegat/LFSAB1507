function [] = testBlurDeblur(test, algo, len, blur_angle)
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

close all;

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
    I = double(imread('Moirebricks.jpg'));
    test_name = 'bricks';
end

%%% Blur the picture
if mod(test,2) == 1
    I = blur(I,len,blur_angle,2);
    L = len;
    angle = blur_angle;
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
    % Needs k = 7 for length_estimator
end

%Pictures on internet
%I = double(imread('Car.jpg'));
%I = double(imread('carRed.jpg'));
%I = double(imread('ambulance.jpg'));
%I = double(imread('Aaron.png'));
%I = double(imread('Sea.png'));

% Taken by us
%I = double(imread('IMG_3993.JPG'));
%I = double(imread('computerGray.jpg'));
%I = double(imread('OfficeGray1HD.jpg'));
%I = double(imread('CarGray2HDCrop.png'));


%%%Show the blurred image
save_image(I, 'g', 2);

%%% Deblur the image

deblurred = deblur(I,algo,0);


%%%Show the deblurred image
save_image(deblurred, 'f', 2);
end
