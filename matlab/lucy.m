function latent_est = lucy(observed, psf, iterations)
    % to utilise the conv2 function we must make sure the inputs are double
    observed = double(observed);
    psf      = double(psf);
    % initial estimate is arbitrary - uniform 50% grey works fine
    latent_est = 0.5*ones(size(observed));
    % create an inverse psf
    psf_hat = psf(end:-1:1,end:-1:1);
    % iterate towards ML estimate for the latent image
    for i = 1:iterations
        est_conv      = conv2(latent_est,psf,'same');
        relative_blur = observed./est_conv;
        error_est     = conv2(relative_blur,psf_hat,'same'); 
        latent_est    = latent_est.* error_est;
    end
end