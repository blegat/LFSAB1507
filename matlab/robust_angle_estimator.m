% B(i,j) = 0 si le pixel est net et 255 s'il est flou
function [angle] = robust_angle_estimator(f, debug, B)
all_blurred = false;
if nargin < 2
    debug = 0;
    if nargin < 3
        blurred = 255 * ones(size(f));
        all_blurred = true;
    end
end

fr = imrotate(f, 45);
Br = imrotate(B, 45);

if all_blurred
    fs = squareborder(f(:,:,1), 0);
else
    fs = biggest_square(f, B);
    %fs = squared_border(f, 0);
end

frs = biggest_square(fr, Br);

thetas = 20:70;

vars = angle_estimator(fs, debug, thetas);
varsr = angle_estimator(frs, debug, thetas);

thetass = [thetas, (thetas - 45)];
varss = [vars varsr];

[osef id] = max(varss);
if debug
    figure
    plot([thetas thetas+(thetas(end)-thetas(1)+1)], varss);
    title('Toutes lse vars');
end

angle = thetass(id);

end