

% La fonction mse calcule le Mean Square Error entre l'image réelle et
% l'image floutée. Une image dont le MSE est plus élevé a une moins bonne
% qualité.
function MSE = mse(I_reelle, I_floutee)
[M,N]=size(I_reelle);
MSE=1/(M*N)*sum(sum((I_reelle-I_floutee).^2));
end



