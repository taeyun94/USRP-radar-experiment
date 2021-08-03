function y = BPSK_mapper(x)

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