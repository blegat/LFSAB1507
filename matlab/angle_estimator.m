function [angle] = angle_estimator (f, debug)
thetas = 0:180;

fs = squareborder(f, 0); % squared
mean(mean(fs));
sum(sum(fs)) / (size(fs, 1) * size(fs, 2));
fc = fs - mean(mean(fs)); % centered

G = fft2(fc);
G = fftshift(G);

rInter = log(1+abs(G));

if debug ==1
    plothot(rInter)
end

angle = find_angle(fc, rInter, thetas, debug);
end

function [t] = find_angle(f, rInter, thetas, debug)
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
plothot(RDiv, thetas, xp);

mid_elemt=round(size(R,1)/2);
mid_size=floor(min(size(f))/4*sqrt(2))-1;
RDiv=RDiv(mid_elemt-mid_size:mid_elemt+mid_size,:);
R=R(mid_elemt-mid_size:mid_elemt+mid_size,:);
if debug ==1
    plothot(R, thetas, xp(mid_elemt-mid_size:mid_elemt+mid_size));
    plothot(RDiv, thetas, xp(mid_elemt-mid_size:mid_elemt+mid_size));
end

if debug ==1
    figure
    plot(thetas,var(R));
    title('Var de la transfo de Radon');
    figure
    plot(thetas,var(R));
    title('Var de la transfo de Radon normalisée');
    %[size1, size2]  = size(R(5:100, 5:175))
end
[m i] = max(var(RDiv));

t = thetas(i);
end

