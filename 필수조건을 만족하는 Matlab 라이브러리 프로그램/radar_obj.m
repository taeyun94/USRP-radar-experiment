function [ch_out]=radar_obj(tx_sym,ch_out,dist,speed,empty_N,tx_pwr,Fs,Fc,SNR,SNR_mod)
proto_flt = rcosdesign(0.2,40,1024,'normal');
proto_flt = proto_flt(1025:end);
for targets_idx = empty_N+1:length(dist)
    if SNR_mod==1
         SNR = -10+40*rand(1); 
    end
%     SNR_buffer( targets_idx )=SNR;
    % distance simulation
    delay = dist(targets_idx)*2/3e8*Fs*1.e6; % # of samples in sampling clock
    int_delay = floor(delay);
    frac_delay = delay - int_delay;
    offset = round(frac_delay*1024);
    delay_flt = proto_flt(offset+1:1024:end);
    delay_flt = delay_flt/sum(delay_flt);
    
    % moving speed simulation
    Doppler_freq = 2*Fc*1.e9*speed(targets_idx)*1000/3600/3e8;
    
    temp = [zeros(int_delay,1); tx_sym];
    ch_out_delay = conv(temp,delay_flt);
    ch_out_delay = ch_out_delay(((length(delay_flt)+1)/2):end-((length(delay_flt)-1)/2));
    ch_out_delay = ch_out_delay(1:length(tx_sym));
    ch_out = ch_out + ch_out_delay.*exp(1j*2*pi*Doppler_freq/Fs*1.e-6*[1:length(ch_out_delay)]') + sqrt(0.5*tx_pwr*10^(-SNR/10))*(randn(size(ch_out_delay))+1j*randn(size(ch_out_delay)));
    
end