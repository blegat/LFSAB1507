function [vars] = angle_estimator (f, debug, thetas)
if nargin < 3
    thetas = 0:180;
end
if debug == 1
    save_image(f, 'hann', 1);
end

fc = f - mean(mean(f)); % centered
G = fft2(fc);
G = fftshift(G);

S = log(1+abs(G));

if debug == 1
    plothot(S, 1:size(S,1), 1:size(S,2), 'S', 2);
end

vars = find_angle(fc, S, thetas, debug);
%vars = find_angle(fc, ones(size(S)), thetas, debug);
end

function [vars] = find_angle(f, S, thetas, debug)
[R, xp] = radon(S,thetas);
if debug == 1
    plothot(R, thetas, xp, 'Rad', 2);
end

IdRad = radon(ones(size(S)), thetas);
if debug == 2
    plothot(IdRad, thetas, xp, 2)
end
RNorm = R;
for i = 1:size(R,1)
    for j = 1:size(R,2)
        if IdRad(i,j) ~= 0
            RNorm(i,j) = R(i,j)/IdRad(i,j);
        end
    end
end

if debug ==1
    plothot(RNorm, thetas, xp, 'RadNorm', 2);
end
mid_elemt=round(size(R,1)/2);
mid_size=floor(min(size(f))/4*sqrt(2))-1;
RNorm=RNorm(mid_elemt-mid_size:mid_elemt+mid_size,:);
R=R(mid_elemt-mid_size:mid_elemt+mid_size,:);
if debug ==1
    %plothot(R, thetas, xp(mid_elemt-mid_size:mid_elemt+mid_size), 'Rad');
    plothot(RNorm, thetas, xp(mid_elemt-mid_size:mid_elemt+mid_size), 'RadFocus', 2);
end

if debug ==1
    save_plot(thetas, var(R), 'Var', 2);
    save_plot(thetas, max(R), 'max', 2);
    save_plot(thetas, var(RNorm), 'VarN', 2);
    save_plot(thetas, max(RNorm), 'maxN', 2);
end
vars = var(RNorm);

end

