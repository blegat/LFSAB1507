% The function mse returns the Mean Square Error between the real image
% and the blurred one. An image for which the MSE is higher has a worse
% quality.
function MSE = mse(I_reelle, I_floutee)
[M,N]=size(I_reelle);
MSE=1/(M*N)*sum(sum((I_reelle-I_floutee).^2));
end