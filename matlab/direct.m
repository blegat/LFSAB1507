function latent_est = direct(observed, mat)
    latent_est = mat \ observed;
end