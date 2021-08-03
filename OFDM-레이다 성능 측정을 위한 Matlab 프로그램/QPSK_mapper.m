function b = QPSK_mapper(a)

N = length(a);
b = zeros(1,N/2);
for i=1:N/2
    two_bit = [a(2*i-1) a(2*i)];
    if two_bit == [1 1]
        b(i) = sqrt(0.5) + j*sqrt(0.5);
    elseif two_bit == [0 1]
        b(i) = -sqrt(0.5) + j*sqrt(0.5);
    elseif two_bit == [1 0]
        b(i) = sqrt(0.5) - j*sqrt(0.5);
    else
        b(i) = -sqrt(0.5) - j*sqrt(0.5);
    end
end