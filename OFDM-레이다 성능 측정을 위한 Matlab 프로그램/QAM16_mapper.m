function y = QAM16_mapper(x)

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
