clear all;  close all;
%% PARAMETER
N_fftpt = 64;
N = 48;
OFDM_symbol=64;
tx_data=zeros(80*OFDM_symbol,1);
mod_Num = 2;      %%%% 1..BPSK   2..QPSK   3..16-QAM
trel = poly2trellis(7,[171 133]);

%% DATA GENERATOR
for n=1:OFDM_symbol
    msg = randi([0 1],1,N);
    conv_msg = convenc(msg,trel);
    mod_msg = mod_sel(conv_msg,mod_Num);
    
    pilot_msg = pilot_insertion(mod_msg);
    sort_msg = ifft_sort(pilot_msg,N_fftpt);
    ifft_msg = ifft_make(sort_msg,N_fftpt);
    data = cp_insert(ifft_msg,N_fftpt);
    tx_data(80*(n-1)+1:80*n)=data;
end

tx_data = tx_data/max(abs(tx_data)); % normalize
% waveform = [zeros(length(tx_data),1); tx_data;];

% save('Waveform_WLAN','tx_data');

% Fs=30.72;
% fig4=figure(4);
% [pxx, f] = pwelch(tx_data , hanning(512), 256, 8192, Fs,'centered','power');
% plot(f,10*log10(pxx),'b','LineWidth',1.5);
% xlabel('frequency (MHz)'); ylabel('power spectral density (dB)');
% axis([-Fs/2 Fs/2 -80 0]);
% grid on;