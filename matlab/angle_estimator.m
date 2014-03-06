function [angle] = angle_estimator (f)
thetas = 0:180;
G = fft2(f);

G = fftshift(G);
rInter = log(abs(G));

angle = find_angle(f, rInter, thetas);
end

function [t] = find_angle(f, rInter, thetas)
R = radon2(rInter,thetas);%, sqrt(2)/2*nm);
[A,xp] = radon(f,thetas);
% IdRad = radon(Id, thetas);
% RDiv = zeros(size(R));
% for i = 1:size(R,1)
%     for j = 1:size(R,2)
%         if IdRad(i,j) ~= 0
%             RDiv(i,j) = R(i,j)/IdRad(i,j);
%         end
%     end
% end

%plot(xp, R)

mid_elemt=round(size(R,1)/2);
mid_size=floor(min(size(f))/4*sqrt(2))-1;
R=R(mid_elemt-mid_size:mid_elemt+mid_size,:);

figure
plot(thetas,var(R));
title('Var de la transfo de Radon');

[m i] = max(var(R));

t = thetas(i);
end
