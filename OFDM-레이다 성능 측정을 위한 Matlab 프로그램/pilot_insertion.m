function y = pilot_insertion(x)

L = length(x);
k = ceil(L/48);
y = zeros(1, k*52);


for n = 1:k
    
    temp = x(48*(n-1) +1 : 48*n); 
    y(52*(n-1)+1:52*n) = [temp(1:5) 1 temp(6:18) 1 temp(19:30) 1 temp(31:43) 1 temp(44:48)]; 
    
end