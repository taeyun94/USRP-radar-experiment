function [log_scale,linear_scale,M_speed_grid,distance_grid]=range_doppler(rx_sig_delay,N_grid_dist,N_grid_speed,Fc,window_idx,N_OFDM_symbol,BW_MHz,N_FFT_point)

S=sprintf('radar_OFDM_sym%d_bw%d_FFT%d.mat',N_OFDM_symbol,BW_MHz,N_FFT_point);
load(S)
% rx_sig_delay=total_rx_sig;
% Fc=5.8;
[output,peak]=cross_corr(tx_sym,rx_sig_delay(:,1),N_fft,L_cp);

ch_out=rx_sig_delay(peak-(L_cp+N_fft)+1:peak-(L_cp+N_fft)+length(tx_sym),2);
eq_mat=radar_mat(ch_out,N_fft,L_cp,N_sym,data_idx,gain,tx_f_block);%레이더 신호 전처리(행렬화)
% N_grid_dist = 4096;% 2D fft poitn for distance
% N_grid_speed = 256;% 2D fft poitn for speed

[log_scale,linear_scale,M_speed_grid,distance_grid]=radar_process(eq_mat,N_grid_dist,N_grid_speed,Fs,L_cp,N_fft,Fc,sc_space,sparse_ratio,window_idx);
distance_grid=-distance_grid;
% figure(3);hold off;
% mesh(speed_range,dist_range,data_set);
% view(2);
% axis([-500 500 0 200 min(min(data_set)) max(max(data_set))])

