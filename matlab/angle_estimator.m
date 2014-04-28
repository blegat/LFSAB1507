function [vars] = angle_estimator (f, debug, thetas)
if nargin < 3
    thetas = 0:180;
end
debug = 1

fc = f - mean(mean(f)); % centered
G = fft2(fc);
G = fftshift(G);

S = log(1+abs(G));

if debug == 1
    plothot(S, 1:size(S,1), 1:size(S,2), 'S');
end

vars = find_angle(fc, S, thetas, debug);
%vars = find_angle(fc, ones(size(S)), thetas, debug);
end

function [vars] = find_angle(f, rInter, thetas, debug)
[R, xp] = radon(rInter,thetas);
if debug == 1
    plothot(R, thetas, xp, 'Rad');
end

IdRad = radon(ones(size(rInter)), thetas);
if debug == 2
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
    plothot(RDiv, thetas, xp, 'RadNorm');
end
mid_elemt=round(size(R,1)/2);
mid_size=floor(min(size(f))/4*sqrt(2))-1;
RDiv=RDiv(mid_elemt-mid_size:mid_elemt+mid_size,:);
R=R(mid_elemt-mid_size:mid_elemt+mid_size,:);
if debug ==1
    %plothot(R, thetas, xp(mid_elemt-mid_size:mid_elemt+mid_size), 'Rad');
    plothot(RDiv, thetas, xp(mid_elemt-mid_size:mid_elemt+mid_size), 'RadFocus');
end

if debug ==1
    save_plot(thetas, var(R), 'Var', 1);
    save_plot(thetas, var(RDiv), 'VarN', 1);
end
vars = var(RDiv);

end

