function tr = ifft_make(x , fft_pt)

L = length(x);
tr = zeros(1,L);

%%ifft��ȯ
for n = 1:L/fft_pt
    tr(fft_pt*(n-1)+1 : fft_pt*n) = ifft(x(fft_pt*(n-1)+1 : fft_pt*n), fft_pt);
end

tr = tr*sqrt(64);
