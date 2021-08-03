function radar_func(total_rx_sig)
load radar_OFDM_sym64_bw20.mat
iter=size(total_rx_sig);
rx_sig_delay=total_rx_sig;
Fc=5.8;
for loop=1:iter(3)
    [output,peak]=cross_corr(tx_sym,rx_sig_delay(:,1,loop));
    
    ch_out=rx_sig_delay(peak-1098+1:peak-1098+length(tx_sym),2,loop);
    eq_mat=radar_mat(ch_out,N_fft,L_cp,N_sym,data_idx,gain,tx_f_block);
    N_grid_dist = 2048;% 2D fft poitn for distance
    N_grid_speed = 256;% 2D fft poitn for speed
    speed_axis=200;
    distance_axis=200;
    [spectrum_for_plot,M_speed_grid,distance_grid]=radar_process(eq_mat,N_grid_dist,N_grid_speed,Fs,L_cp,N_fft,Fc,sc_space,sparse_ratio);
    
    [data_set,speed_idx1,speed_idx2,distance_idx1,distance_idx2]=data_gen(spectrum_for_plot,speed_axis,distance_axis,M_speed_grid,distance_grid);
    
    speed_range=M_speed_grid(speed_idx1:speed_idx2);
    dist_range=(-distance_grid(distance_idx1:distance_idx2));
    
    %     fig1=figure(2);hold off;
    %     imshow(data_set);
    
    %     set([fig1], 'OuterPosition', [2000, 500, 500, 450]); % Right moniter
    
    figure(3);hold off;
    mesh(speed_range,dist_range,data_set);
    view(2);
    axis('tight')
    figure(2);hold off;
    imshow(data_set);
    view(2);
end
