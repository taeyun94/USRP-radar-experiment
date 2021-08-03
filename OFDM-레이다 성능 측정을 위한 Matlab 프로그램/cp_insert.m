
function y = cp_insert(x,fft_pt)

if(fft_pt == 64)
    cp = 16;
else
    cp = 32;
end

L=length(x);
y = zeros(1,L/fft_pt*cp+L);
% temp = zeros(1,fft_pt);

for n= 1: L/fft_pt
    temp = x(fft_pt*(n-1)+1 : fft_pt*n);
    
    y((fft_pt+cp)*(n-1)+1 : (fft_pt+cp)*n) = [temp(end-cp+1:end) temp];
        
end