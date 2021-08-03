function eq_mat=radar_mat(ch_out,N_fft,L_cp,N_sym,data_idx,gain,tx_f_block)
rx_mat = reshape(ch_out,L_cp+N_fft,N_sym);
rx_t_block = rx_mat(L_cp+1:end,:);
rx_f_block = zeros(length(data_idx),N_sym);
for n=1:N_sym
    temp = fft(rx_t_block(:,n),N_fft);
    temp1 = temp(data_idx);
    rx_f_block(:,n) =  temp1([round(length(temp1)/2)+1:length(temp1), 1:round(length(temp1)/2)]);
end
rx_f_block = rx_f_block/sqrt(N_fft)*gain;
%% 

eq_mat = rx_f_block.*conj(tx_f_block);