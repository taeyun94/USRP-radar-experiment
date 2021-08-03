function [output,speed_grid,distance_grid]=radar_process(eq_mat,N_grid_dist,N_grid_speed,Fs,L_cp,N_fft,Fc,sc_space,sparse_ratio)

Max_Doppler = Fs*1.e6/(L_cp+N_fft);
Doppler_grid = linspace(-Max_Doppler/2,Max_Doppler/2,N_grid_speed);
speed_grid = 0.5*Doppler_grid*3e8/Fc/1.e9*3600/1000;

Delay_grid = linspace(-1/sc_space*1.e-3/2,1/sc_space*1.e-3/2,N_grid_dist);
distance_grid = Delay_grid*3e8/2/sparse_ratio;

% a = max(abs(spectrum_3d),[],1);
% peak = max(a);

% spectrum_shift = fftshift(spectrum_3d);

[row,col] = size(eq_mat);
%     win = ones(row,1);
win = hanning(row);
% win = blackmanharris(row);
% win = hamming(row);
% win = chebwin(row,80);
eq_mat_win = zeros(size(eq_mat));
for n=1:col
    eq_mat_win(:,n) = eq_mat(:,n).*win;
end
%     win = ones(col,1)';
win = hanning(col)';
% win = blackmanharris(col)';
% win = hamming(col)';
% win = chebwin(col,80)';
for n=1:row
    eq_mat_win(n,:) = eq_mat_win(n,:).*win;
end

spectrum_3d_win = fft2(eq_mat_win,N_grid_dist,N_grid_speed);
spectrum_shift = fftshift(spectrum_3d_win);

output = log10(max(abs(spectrum_shift).^2,1.e-6));
% output = max(abs(spectrum_shift).^2,1.e-6);