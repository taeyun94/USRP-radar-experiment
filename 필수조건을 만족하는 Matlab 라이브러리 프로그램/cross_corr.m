function [output,peak,max_value]=cross_corr(preamble,data)
output=zeros(1,length(data)/2);

preamble=preamble(1:1098);
register=zeros(1,length(preamble));
for n=1:length(data)/2
    register=circshift(register,-1);
    register(end)=data(n);
    output(n)=sum((preamble.').*conj(register));    
end
[max_value,peak]=max(abs(output));

