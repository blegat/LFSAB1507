function [ angle ] = angle_estimator_Gabor(f, thetamin, thetamax)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if nargin < 2
    thetamin = 0;
    thetamax= 180;
end

fc = f - mean(mean(f)); % centered

F = fft2(fc);
F = fftshift(F);

I = log(F);

sigma_x=3;
sigma_y=3;
w=1.75;
G=f;
Rnorm=zeros(thetamax-thetamin+1);
[m n]=size(f);
for theta=thetamin:thetamax
   for k=1:m
    for l=1:n
        G(k,l)=1/(2*pi*sigma_x*sigma_y)*exp(-(k^2/sigma_x^2+l^2/sigma_y^2)/2)*exp(-i*w*(k*cos(theta)+l*sin(theta)));
    end
   end
   R=conv2(f,G);
   Rnorm(theta-thetamin+1)=norm(R,2);
end

[max,angle]=max(Rnorm);

end

