function SNR = snr(s,x)
[M,N]=size(s);
d=s-x;
S=fft2(s);
D=fft2(d);
PS=sum(sum(abs(S).^2)/(M*N));
PD=sum(sum(abs(D).^2)/(M*N));
SNR=PS/PD;
end