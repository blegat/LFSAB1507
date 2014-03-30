% B(i,j) = 0 si le pixel est net et 255 s'il est flou
function [angle] = robust_angle_estimator(f, debug, B)
all_blurred = false;
if nargin < 2
    debug = 0;
    if nargin < 3
        blurred = 255 * ones(size(f(:,:,1)));
        all_blurred = true;
    end
end

fr = imrotate(f(:,:,1), 45);
Br = imrotate(B, 45);

if all_blurred
    fs = squareborder(f(:,:,1), 0);
else
    fs = biggest_square(f(:,:,1), B, debug);
    %fs = squared_border(f, 0);
end

frs = biggest_square(fr, Br, debug);
%save_image(frs,'frs',2);
thetas = [20:70, 110:160];
% [len wid] = size(frs);
% vars = angle_estimator(fs([1:len],[1:wid]), debug, thetas);
vars = angle_estimator(fs, debug, thetas);
varsr = angle_estimator(frs, debug, thetas);

thetass = [thetas, (thetas - 45)];
varss = [vars varsr];
[osef id] = max(varss);
if true
    figure
    plot(thetas, vars, '+', thetas-45, varsr, '+');
    title('Toutes les vars');
    legend('unchanged', 'rotated by 45°');
end

angle = thetass(id);

end