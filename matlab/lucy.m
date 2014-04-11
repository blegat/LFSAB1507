function latent_est = lucy(observed, psf, len, angle, iterations, debug, meth, mask)
    %if nargin < 4
    if nargin < 7
        meth = 1;
    end
    %end
    if meth == 1
        latent_est = deconvlucy(observed, psf, iterations);
    elseif meth == 2
        % to utilise the conv2 function we must make sure the inputs are double
        observed = double(observed);
        psf      = double(psf);
        latent_est = observed;
        % initial estimate is arbitrary - uniform 50% grey works fine
        latent_est(mask) = 128;
        % create an inverse psf
        psf_hat = psf(end:-1:1,end:-1:1);
        % iterate towards ML estimate for the latent image
        for i = 1:iterations
            % latent_est est l'estimation actuelle,
            % voyons voir ce que ça donne en le floutant
            est_conv         = conv2(latent_est, psf, 'same');
            relative_blur    = observed ./ est_conv;
            % pour chaque pixel, on regarde l'erreur sous
            % la forme d'un coefficient correcteur
            % e.g. si ça vaut 6 et non 12, on se dit qu'il faudrait
            % faire x2 au pixels qui sont convolués pour avoir ce pixel
            error_est        = conv2(relative_blur, psf_hat, 'same');
            % Pour chaque pixel, on regarde les coefficients correcteurs
            % de tous les pixels qui sont influencés par ce pixel là
            % lors de la convolution et on fait une convolution
            % (en gros la moyenne) de ces coefficients.
            % Pour faire celà, on fait la convolution de la matrice
            % des coefficients correcteurs avec la PSF inverse

            % N'updatons que le foreground par contre :D
            latent_est(mask) = latent_est(mask) .* error_est(mask);
        end
    else
        centered_psf = oneway_psf(len, angle);
        centered_psf_hat = centered_psf(end:-1:1,end:-1:1);
        if debug
            figure
            subplot(1,2,1);
            imshow(centered_psf*len);
            subplot(1,2,2);
            imshow(centered_psf_hat*len);
        end

        observed = double(observed);
        %psf = double(psf);
        angle = angle + 90;
        [insidex marginx] = getInsideMargin(size(observed, 1), len*cos(angle/180*pi));
        [insidey marginy] = getInsideMargin(size(observed, 2), len*sin(angle/180*pi));

        margin = observed;% could do better with mean shift
        %cheat = double(imread('cameraman.tif'));
        %margin = cheat;
        margin(insidex,insidey) = 0;
        margin = imfilter(margin, centered_psf);
        if debug
            save_image(margin, 'margin', 2);
        end
        inside = observed;
        inside = inside - margin;
        inside(inside < 0) = 0; % when margin is greater
        inside(marginx,:) = 0;
        inside(:, marginy) = 0;
        if debug
            save_image(inside, 'inside', 2);
        end

        %latent_est = inside;
        latent_est = 255*ones(size(inside))/2;
        latent_est(marginx,:) = 0;
        latent_est(:,marginy) = 0;

        for i = 1:iterations
            if debug
                figure
                subplot(3,2,1)
                imshow(inside/255);
                subplot(3,2,2);
                imshow(latent_est/255);
            end
            %est_conv         = filter2(psf, latent_est, 'same');
            est_conv = imfilter(latent_est, centered_psf);
            if debug
                subplot(3,2,3);
                imshow(est_conv/255);
            end
            % We take the difference with one so that
            % if a pixel influence in total, less than 1 pixel,
            % it does not get dark
            relative_blur    = inside ./ est_conv - 1;
            relative_blur(est_conv == 0) = 0;
            if debug
                subplot(3,2,4);
                imshow((relative_blur+0.5)/2.55);
            end
            %rev_relative_blur = relative_blur(end:-1:1,end:-1:1);
            %error_est = filter2(psf, rev_relative_blur, 'same');
            %error_est = imfilter(rev_relative_blur, centered_psf, 'replicate');
            %error_est = error_est(end:-1:1,end:-1:1);
            error_est = 1 + imfilter(relative_blur, centered_psf_hat);
            if debug
                subplot(3,2,5);
                imshow((error_est-0.5)/2.55);
            end
            latent_est       = latent_est .* error_est;
            if debug
                subplot(3,2,6);
                imshow(latent_est/255);
            end
        end
        %latent_est(marginx,:) = observed(marginx+len/2,:);
        %latent_est(:,marginy) = observed(:,marginy+len/2);
        latent_est(marginx,:) = observed(marginx,:);
        latent_est(:,marginy) = observed(:,marginy);
    end
end

function [inside margin] = getInsideMargin(n, m)
m = ceil(m);
if m < 0
    m = abs(m);
    margin = n+1-m:n;
    inside = 1:n-m;
else
    m = abs(m);
    margin = 1:m;
    inside = m+1:n;
end
end
