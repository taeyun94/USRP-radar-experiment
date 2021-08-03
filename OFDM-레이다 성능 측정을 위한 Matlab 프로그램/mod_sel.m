function y = mod_sel(x,Mod_Num)

if Mod_Num == 1
    one_bit = [ 0 ];
L = length(x);
y = zeros(1,L);

for n=1:L
    one_bit = x(n);
    
    if( one_bit == [ 0 ] )
        y(n) = 1;
    else
        y(n) = -1;
    end
end
elseif Mod_Num == 2
    N = length(x);
y = zeros(1,N/2);
for i=1:N/2
    two_bit = [x(2*i-1) x(2*i)];
    if two_bit == [1 1]
        y(i) = sqrt(0.5) + j*sqrt(0.5);
    elseif two_bit == [0 1]
        y(i) = -sqrt(0.5) + j*sqrt(0.5);
    elseif two_bit == [1 0]
        y(i) = sqrt(0.5) - j*sqrt(0.5);
    else
        y(i) = -sqrt(0.5) - j*sqrt(0.5);
    end
end
else
    L = length(x);
y = zeros(1,L/4);
for n = 1 : L/4
    four_bits = x(4*(n-1)+1:4*n);
    if four_bits == [0, 0, 0, 0]
        y(n) = -3-3j;
    elseif four_bits == [0, 0, 0, 1]
        y(n) = -3-j;
    elseif four_bits == [0, 0, 1, 1]
        y(n) = -3+j;
    elseif four_bits == [0, 0, 1, 0]
        y(n) = -3+3j;
    
    elseif four_bits == [0, 1, 0, 0]
        y(n) = -1-3j;
    elseif four_bits == [0, 1, 0, 1]
        y(n) = -1-j;
    elseif four_bits == [0, 1, 1, 1]
        y(n) = -1+j;
    elseif four_bits == [0, 1, 1, 0]
        y(n) = -1+3j;
    
    elseif four_bits == [1, 1, 0, 0]
        y(n) = 1-3j;
    elseif four_bits == [1, 1, 0, 1]
        y(n) = 1-j;
    elseif four_bits == [1, 1, 1, 1]
        y(n) = 1+1j;
    elseif four_bits == [1, 1, 1, 0]
        y(n) = 1+3j;        
    
    elseif four_bits == [1, 0, 0, 0]
        y(n) = 3-3j;        
    elseif four_bits == [1, 0, 0, 1]
        y(n) = 3-1j;        
    elseif four_bits == [1, 0, 1, 1]
        y(n) = 3+j;        
    elseif four_bits == [1, 0, 1, 0]
        y(n) = 3+3j;
    end
end

y = y/sqrt(10);
end