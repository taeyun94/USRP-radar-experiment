clc
clear

Fs = 30.72; % sampling frequency
BW = 20; % bandwidth in MHz
sc_space = Fs/1024*1000000; % subcarrier space
N_sym = 64; % length of OFDM symbols
L_cp = 74; % length of CP
N_fft = Fs/sc_space*1000000;
N_use = (floor(round(BW/Fs*N_fft)/12)-4)*12; %1284
N_g = N_fft-N_use; %2812
sparse_ratio = 1;
ch_idx = 1;
data_t = randi([0 3], N_use*N_sym/sparse_ratio, 1); %1284*64x1
SYM_t = qammod(data_t, 4);

N_obj=4;
Fc=5.3;
SNR_mode=0;
SNR=10;

data_idx_full = [1:N_fft/2-N_g/2, N_fft/2+N_g/2+1:N_fft]; %1~642,3455~4096
data_idx = data_idx_full(ch_idx:sparse_ratio:end);

win = hanning(128);
tx_sym = zeros((N_fft+L_cp)*N_sym,1);
tx_f_block = zeros(length(data_idx),N_sym);

for sym_idx=1:N_sym
    SYM = SYM_t(N_use/sparse_ratio*(sym_idx-1)+1:N_use/sparse_ratio*sym_idx); %1~1284, 1285~2568
    Mod_gain = sqrt(2);
    SYM = SYM/Mod_gain; 
    % IFFT
    in = zeros(N_fft,1);
    in(data_idx)= SYM; %1~642,3455~4096 
    % save frequency-domain symbol
    tx_f_block(:,sym_idx) = SYM([round(length(SYM)/2)+1:length(SYM), 1:round(length(SYM)/2)]);
    temp = ifft(in,N_fft)*sqrt(N_fft);
    temp1 = ifft(in,N_fft)*sqrt(N_fft);
    temp(1:length(win)/2) = temp(1:length(win)/2).*win(1:length(win)/2);
    temp(end-length(win)/2+1:end) = temp(end-length(win)/2+1:end).*win(length(win)/2+1:end);
    tx_sym((N_fft+L_cp)*(sym_idx-1)+1:(N_fft+L_cp)*sym_idx) = [temp(end-L_cp+1:end); temp];
end
gain = sqrt(mean(abs(tx_sym).^2));
tx_sym = tx_sym/gain;
% tx_pwr = sqrt(mean(abs(tx_sym).^2));
tx_sym = tx_sym/max(abs(tx_sym)); % normalize

% save Waveform_OFDM_bw20.mat
