% Test with the real image realf blurred by a psf (or by mat)
% so f = conv(psf, realf) + noise or f = mat * realf
% with the name and display the results if graph = 1 or
% save the result if graph = 2
function [] = tester (realf, psf, mat, noise, name, graph)
load fille;
save_image(realf, sprintf('start-%s', name), graph);

fmat = noise(mat * realf);
save_image(fmat, sprintf('matb-%s', name), graph);
save_image(direct(fmat, mat), sprintf('direct-%s', name), graph);

fpsf = noise(conv2(realf, psf, 'same'));
save_image(fpsf, sprintf('psfb-%s', name), graph);
save_image(lucy(fpsf, psf, 10), sprintf('lucy-%s', name), graph);

end
