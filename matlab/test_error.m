clear all;
debug = 0;
if debug == 0
    n = 50;
    m = 100;
    K = 8;
else
    n = 5;
    m = 20;
    K = 4;
end
I = [255*ones(n,m/2) zeros(n,m/2)];
blur = (build_H(K,m) * I')';
ks = 1:2*K;
plots = zeros(numel(ks),2);
for k = ks
    unblur = (build_H(k,m) \ blur')';
    save_image(unblur, 'unblurred', 2);
    plots(k,1) = error1(unblur);
    plots(k,2) = error2(unblur);
end
semilogy(ks, plots);