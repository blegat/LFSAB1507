function latent_est = lucy(observed, psf, iterations, mask)
    %if nargin < 4
        meth = 2;
    %end
    if meth == 1
        latent_est = deconvlucy(observed, psf, iterations);
    else
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
    end
end