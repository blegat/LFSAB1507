
% La fonction psnr calcule le Peak Signal-to-Noise entre l'image réelle et
% l'image floutée. Elle prend également la valeur maximale autorisée pour
% les pixels. Cette méthode est meilleur que le MSE car il dépend
% moins de l'échelle d'intensité de l'image. Une image dont le PSNR est
% plus élevé est de meilleure qualité.

function PSNR = psnr(I_reelle, I_floutee, S)
MSE=mse(I_reelle, I_floutee);
PSNR=-10*log10(MSE/S^2);
end
