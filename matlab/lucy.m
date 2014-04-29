function latent_est = lucy(observed, psf, len, angle, iterations, debug, meth, mask, bg)
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
            % let's see what is looks like when it's blurred
            est_conv         = conv2(latent_est, psf, 'same');
            relative_blur    = observed ./ est_conv;
            % pour chaque pixel, on regarde l'erreur sous
            % la forme d'un coefficient correcteur
            % e.g. si ca vaut 6 et non 12, on se dit qu'il faudrait
            % faire x2 au pixels qui sont convolues pour avoir ce pixel
            error_est        = conv2(relative_blur, psf_hat, 'same');
            % Pour chaque pixel, on regarde les coefficients correcteurs
            % de tous les pixels qui sont influences par ce pixel la
            % lors de la convolution et on fait une convolution
            % (en gros la moyenne) de ces coefficients.
            % Pour faire cela, on fait la convolution de la matrice
            % des coefficients correcteurs avec la PSF inverse

            % N'updatons que le foreground par contre :D
            latent_est(mask) = latent_est(mask) .* error_est(mask);
        end
    elseif meth == 3
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
    elseif meth == 4
        observed = imrotate(observed, angle);
        mask = imrotate(mask, angle);
        bg = imrotate(bg, angle);
        [n m] = size(observed);
        slope = zeros(n, m-len);
        % 0,1,...,len <- len+1 diff
        L = len+1;
        K = len;
        %mask(150,1:m) = 1:m;
        for k = 1:n
            % slope = SXY / SXX
            % SXX = m_2x - m_1x**2
            % SXY = m_2xy - m_1x * m_1y
            x = 1:L;
            y = mask(k,x);
            s_1x = sum(x);
            s_1y = sum(y);
            s_2x = sum(x.*x);
            s_2xy = sum(x.*y);
            slope(k,1) = (s_2xy - L * s_1x * s_1y) / (s_2x - L*s_1x*s_1x);
            for j = 2:size(slope,2)
                prevx = j-1;
                nextx = j+L-1;
                prevy = mask(k,prevx);
                nexty = mask(k,nextx);
                s_1x = (s_1x - prevx + nextx);
                s_1y = (s_1y - prevy + nexty);
                s_2x = (s_2x - prevx*prevx + nextx*nextx);
                s_2xy = (s_2xy - prevx*prevy + nextx*nexty);
                slope(k,j) = (s_2xy - s_1x*s_1y/L) / (s_2x - s_1x*s_1x/L);
            end
        end
        if debug
            save_image(abs(slope)/max(max(abs(slope))) * 255, 'slope', 2);
        end
        start = m*ones(n,1);
        endit = ones(n,1);
        contour = zeros(n, m);
        threshold = 0.1;
        for k = 1:n
            for j = K+1:size(slope,2)-K
                if slope(k,j) > threshold && slope(k,j) == max(slope(k,j-K:j+K)) % j-K:j also makes sense
                    start(k) = j;
                    break;
                end
            end
        end
        for k = 1:n
            for j = size(slope,2)-K:-1:K+1
                if slope(k,j) < -threshold && slope(k,j) == min(slope(k,j-K:j+K)) % j:j+K is also nice
                    endit(k) = j;
                    break;
                end
            end
        end
        for k = 1:n
            if start(k) <= endit(k)
                contour(k,start(k):endit(k)) = 1;
            end
        end

        centered_psf = oneway_psf(len, 0);
        centered_psf_hat = centered_psf(end:-1:1,end:-1:1);
        % blurred foreground
        Bcontour = imfilter(contour, centered_psf);
        if debug
            figure
            subplot(2,2,1);
            imshow(mask/255);
            subplot(2,2,2);
            imshow(contour)
            subplot(2,2,3)
            %imshow(abs(slope) / max(max(abs(slope))));
            imshow(abs(slope));
            %slope2(150,:)
            %plot(1:m-len,slope1(150,:), 1:m-len,slope2(150,:), '+');
            %legend('slope1', 'slope2');
            subplot(2,2,4)
            imshow(Bcontour);
        end
        fg = observed;
        fg = fg - bg .* (1 - Bcontour);
        fg(Bcontour == 0) = 0; % avoid negative
        if debug
            save_image(fg, 'foreground', 2);
        end

        latent_est = contour; % grey
        for i = 1:iterations
            if debug
                figure
                subplot(3,2,1);
                imshow(fg/255);
                subplot(3,2,2);
                imshow(latent_est/255);
                title(latent_est);
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
            relative_blur    = fg ./ est_conv - 1;
            relative_blur(est_conv == 0) = 0;
            if debug
                subplot(3,2,4);
                imshow(relative_blur);
            end
            %rev_relative_blur = relative_blur(end:-1:1,end:-1:1);
            %error_est = filter2(psf, rev_relative_blur, 'same');
            %error_est = imfilter(rev_relative_blur, centered_psf, 'replicate');
            %error_est = error_est(end:-1:1,end:-1:1);
            error_est = 1+imfilter(relative_blur, centered_psf_hat);
            if debug
                subplot(3,2,5);
                imshow(error_est);
            end
            latent_est       = latent_est .* (error_est);
            if debug
                subplot(3,2,6);
                imshow(latent_est/255);
            end
            %figure
            %imshow(latent_est/255)
        end
        latent_est = latent_est + bg .* (1 - contour);
        if debug
            save_image(latent_est, 'latent_est', 2);
        end
        latent_est = imrotate(latent_est, -angle);
        if debug
            save_image(latent_est, 'latent_est rotated', 2);
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
        [n m] = size(observed);
        N = n + len;
        M = m + len;
        angle = angle + 90;
        [insidex marginx] = getInsideMargin(N, len*sign(cos(angle/180*pi)));
        [insidey marginy] = getInsideMargin(M, len*sign(sin(angle/180*pi)));
        %[insidex marginx] = getInsideMargin(N, len);
        %[insidey marginy] = getInsideMargin(M, len);

        inside = zeros(N, M);% could do better with mean shift
        %cheat = double(imread('cameraman.tif'));
        %margin = cheat;
        inside(insidex,insidey) = observed;
        if debug
            save_image(inside, 'inside', 2);
        end

        %latent_est = inside;
        big_latent_est = 255*ones(size(inside))/2;

        for i = 1:iterations
            if debug
                figure
                subplot(3,2,1)
                imshow(inside/255);
                subplot(3,2,2);
                imshow(big_latent_est/255);
            end
            %est_conv         = filter2(psf, latent_est, 'same');
            est_conv = imfilter(big_latent_est, centered_psf);
            if debug
                subplot(3,2,3);
                imshow(est_conv/255);
            end
            % We take the difference with one so that
            % if a pixel influence in total, less than 1 pixel,
            % it does not get dark
            relative_blur    = inside ./ est_conv - 1;
            relative_blur(marginx,:) = 0;
            relative_blur(:,marginy) = 0;
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
            big_latent_est       = big_latent_est .* error_est;
            if debug
                subplot(3,2,6);
                imshow(big_latent_est/255);
            end
        end
        %latent_est(marginx,:) = observed(marginx+len/2,:);
        %latent_est(:,marginy) = observed(:,marginy+len/2);
        %latent_est(marginx,:) = observed(marginx,:);
        %latent_est(:,marginy) = observed(:,marginy);
        if debug
            save_image(big_latent_est, 'fullmagic', 2);
        end
        latent_est = big_latent_est(insidex,insidey);
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
