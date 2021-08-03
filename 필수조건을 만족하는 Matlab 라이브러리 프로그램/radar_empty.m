function [ch_out]=radar_empty(tx_sym,dist,empty_N,tx_pwr,Fs,SNR,SNR_mod)
proto_flt = rcosdesign(0.2,40,1024,'normal');
proto_flt = proto_flt(1025:end);
if SNR_mod==1
    SNR = -30+40*rand(1); % SNR in dB  -30 ~ 10  ->  -20 ~ 20
end
% SNR_buffer=zeros(1,length(dist));
if empty_N==0
    ch_out=zeros(size(tx_sym)) + sqrt(0.5*tx_pwr*10^(-SNR/10))*(randn(size(tx_sym))+1j*randn(size(tx_sym)));
else
    for targets_idx = 1:empty_N
        %         SNR_buffer(targets_idx)=SNR;
        % distance simulation
        delay = dist(targets_idx)*2/3e8*Fs*1e6; % # of samples in sampling clock
        int_delay = floor(delay);
        frac_delay = delay - int_delay;
        offset = round(frac_delay*1024);
        delay_flt = proto_flt(offset+1:1024:end);
        delay_flt = delay_flt/sum(delay_flt);
        
        temp = [zeros(int_delay,1); tx_sym];
        ch_out_delay = conv(temp,delay_flt);
        ch_out_delay = ch_out_delay(((length(delay_flt)+1)/2):end-((length(delay_flt)-1)/2));
        ch_out_delay = ch_out_delay(1:length(tx_sym));
        if targets_idx == 1
            ch_out = ch_out_delay + sqrt(0.5*tx_pwr*10^(-SNR/10))*(randn(size(ch_out_delay))+1j*randn(size(ch_out_delay)));
        else
            ch_out = ch_out + ch_out_delay + sqrt(0.5*tx_pwr*10^(-SNR/10))*(randn(size(ch_out_delay))+1j*randn(size(ch_out_delay)));
        end
    end
end