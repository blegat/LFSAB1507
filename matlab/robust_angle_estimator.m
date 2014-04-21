% B(i,j) = 0 si le pixel est net et 255 s'il est flou
function [angle] = robust_angle_estimator(f, debug, B)
all_blurred = false;

if nargin < 3
    B = 255 * ones(size(f(:,:,1)));
    all_blurred = true;
    if nargin < 2
        debug = 0;
    end
end


%save_image(frs,'frs',2);
thetas = 0:180;
%turns = [0 45];
turns = [0];
vars = zeros(numel(turns), numel(thetas));

n_hann = 1;

epsilon = 1;
best = zeros(numel(turns), numel(turns));
for i = 1:numel(turns)
    % [len wid] = size(frs);
    % vars = angle_estimator(fs([1:len],[1:wid]), debug, thetas);
    turn = turns(i);
    
    if turn == 0
        if all_blurred
            fs = squareborder(f(:,:,1), 0);
        else
            fs = biggest_square(f(:,:,1), B, debug);
        end
    else
        fr = imrotate(f(:,:,1), turn);
        Br = imrotate(B, turn);
        fs = biggest_square(fr, Br, debug);
    end
    
    if n_hann > 0
        w_hann1 = hann(size(fs,1));
        w_hann2 = w_hann1(:)*w_hann1(:).';
    end
    for i_hann = 1:n_hann
        fs = w_hann2 .* fs;
    end
    
    if debug
        save_image(fs, 'hann', 2);
    end
    
    vars(i,:) = angle_estimator(fs, debug, thetas);

    if debug
        plot(thetas, vars(i,:)); hold on
    end

    if false
        % indexes starts at 0 so angles are shifted by 1
        intervals = [1 91; 91 181];
        nint = size(intervals, 1);
        found = false;
        % Tant qu'on a pas trouvé et qu'il reste des intervaux non-vides
        while max(abs(diff(intervals'))) > 0 && ~found
            maxs = zeros(1, nint);
            for j = 1:nint
                if intervals(j,1) < intervals(j,2)
                    interval = intervals(j,1):intervals(j,2);
                    cur_thetas = thetas(intervals(j,1):intervals(j,2));
                    [maxs(j,1) index] = max(vars(i,interval));
                    maxs(j,2) = cur_thetas(index);
                else
                    maxs(j,1) = -inf;
                end
            end
            [best(i, 1) max_index] = max(maxs(:, 1));
            best(i, 2) = maxs(max_index, 2)
            
            if min(min(abs(thetas(intervals) - best(i,2)))) < epsilon
                % On doit rogner
                index_in_thetas = find(thetas == best(i,2), 1);
                for j = 1:nint
                    if thetas(intervals(j,1)) <= best(i,2) && best(i,2) <= thetas(intervals(j,2))
                        if abs(thetas(intervals(j,1)) - best(i,2)) < epsilon
                            intervals(j,1) = index_in_thetas+1;
                        end
                        if abs(thetas(intervals(j,2)) - best(i,2)) < epsilon
                            intervals(j,2) = index_in_thetas-1;
                        end
                    end
                end
            else
                found = true;
            end
        end
        if ~found % On a pas trouvé et les intervals sont vides
            best(i, 2) = 45; % FIXME trouver un truc mieux à faire
            best(i, 1) = -inf;
        end
    else
        [best(i,1) best(i,2)] = max(vars);
        best(i,2) = thetas(best(i,2));
    end
end

best_index = argmax(best(:, 1));

angle = best(best_index, 2) - turns(best_index);

end
