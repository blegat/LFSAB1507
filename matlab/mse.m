

% La fonction mse calcule le Mean Square Error entre l'image r�elle et
% l'image flout�e. Une image dont le MSE est plus �lev� a une moins bonne
% qualit�.
function MSE = mse(I_reelle, I_floutee)
[M,N]=size(I_reelle);
MSE=1/(M*N)*sum(sum((I_reelle-I_floutee).^2));
end



