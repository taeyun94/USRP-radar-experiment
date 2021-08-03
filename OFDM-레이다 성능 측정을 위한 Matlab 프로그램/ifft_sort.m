function y = ifft_sort(x,fft_pt)
k = length(x)/52;
% pad = mod(length(x),52);
% 
% if pad ~= 0  x_padding = zeros(1,length(x)+(52-pad));
%              x_padding(1:length(x)) = x;
% else         x_padding = x;
% end

y = zeros(1,k*fft_pt);
temp = zeros(1,52);

if(fft_pt == 64)
    a = 11;
else
    a = 75;
end


for n=1:k
    
   temp = x(52*(n-1) +1 : 52*n); 
   y(fft_pt*(n-1)+1:fft_pt*n) = [0 temp(27:52) zeros(1,a) temp(1:26)]; 
%      y(128*(n-1)+1:128*n) = [0 temp(1:26) zeros(1,75) temp(27:52)]; 
end

