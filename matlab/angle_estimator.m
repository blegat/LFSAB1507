function [angle] = angle_estimator (f)
thetas = 0:180;
G = fft2(f);

G = fftshift(G);
rInter = log(abs(G));

angle = find_angle(f, rInter, thetas);
end

function [t] = find_angle(f, rInter, thetas)
R = radon2(rInter,thetas);

mid_elemt=round(size(R,1)/2);
mid_size=floor(min(size(f))/4*sqrt(2))-1;
R=R(mid_elemt-mid_size:mid_elemt+mid_size,:);

figure
plot(thetas,var(R));
title('Var de la transfo de Radon');
[size1, size2]  = size(R(5:100, 5:175))
[m i] = max(var(R));

t = i-1; 
end
