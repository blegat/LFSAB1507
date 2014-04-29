function [ angle ] = angle_estimator_Gabor(f, thetamin, thetamax)
%ANGLE_ESTIMATOR_GABOR Estimates the blur angle with the Gabor filter
%   input: f is the blurred image. thetamin and thetamax is an interval
%   that contains the blur angle. If they are not given, they are set 0 and
%   180 respectively.

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
G=f; % G has the same dimensions as f
Rnorm=zeros(1,thetamax-thetamin+1);
[m n]=size(f);
for theta=thetamin:thetamax
   for k=1:m
    for l=1:n
        G(k,l)=1/(2*pi*sigma_x*sigma_y)*exp(-(k^2/sigma_x^2+l^2/sigma_y^2)/2)*exp(-1i*w*(k*cos(theta)+l*sin(theta)));
    end
   end
   R=conv2(I,G);
   Rnorm(theta-thetamin+1)=norm(R,2);
end

[~,angle]=max(Rnorm);
angle = angle + thetamin-1;

end

