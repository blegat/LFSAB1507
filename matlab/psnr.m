
% La fonction psnr calcule le Peak Signal-to-Noise entre l'image r�elle et
% l'image flout�e. Elle prend �galement la valeur maximale autoris�e pour
% les pixels. Cette m�thode est meilleur que le MSE car il d�pend
% moins de l'�chelle d'intensit� de l'image. Une image dont le PSNR est
% plus �lev� est de meilleure qualit�.

function PSNR = psnr(I_reelle, I_floutee, S)
MSE=mse(I_reelle, I_floutee);
PSNR=-10*log10(MSE/S^2);
end
