function [vars] = angle_estimator (f, debug, thetas)
if nargin < 3
    thetas = 0:180;
end

fc = f - mean(mean(f)); % centered

G = fft2(fc);
G = fftshift(G);

rInter = log(1+abs(G));

if debug ==1
    plothot(rInter);
end

vars = find_angle(fc, rInter, thetas, debug);
end

function [vars] = find_angle(f, rInter, thetas, debug)
[R, xp] = radon(rInter,thetas);
if debug ==1
    plothot(R, thetas, xp);
end

IdRad = radon(ones(size(rInter)), thetas);
if debug ==2
    plothot(IdRad, thetas, xp)
end
RDiv = R;
for i = 1:size(R,1)
    for j = 1:size(R,2)
        if IdRad(i,j) ~= 0
            RDiv(i,j) = R(i,j)/IdRad(i,j);
        end
    end
end

if debug ==1
    plothot(RDiv, thetas, xp);
end
% mid_elemt=round(size(R,1)/2);
% mid_size=floor(min(size(f))/4*sqrt(2))-1;
% RDiv=RDiv(mid_elemt-mid_size:mid_elemt+mid_size,:);
% R=R(mid_elemt-mid_size:mid_elemt+mid_size,:);
if debug ==1
    plothot(R, thetas, xp(mid_elemt-mid_size:mid_elemt+mid_size));
    plothot(RDiv, thetas, xp(mid_elemt-mid_size:mid_elemt+mid_size));
end

if debug ==1
    figure
    plot(thetas,var(R), thetas, max(R));
    title('Var de la transfo de Radon');
    figure
    plot(thetas,var(RDiv), thetas, max(RDiv));
    title('Var de la transfo de Radon normalisée');
    %[size1, size2]  = size(R(5:100, 5:175))
end
vars = max(RDiv);

end

