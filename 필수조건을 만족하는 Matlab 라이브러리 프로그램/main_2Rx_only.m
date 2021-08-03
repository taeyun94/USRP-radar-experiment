% Ettus Research USRP X310 test, 1Tx(Signal generator) 2Rx(X310)
% Development Environment : Windows 10, Matlab R2020a

clc
connectedRadios = findsdru;
if strncmp(connectedRadios(1).Status, 'Success', 7)
    address = connectedRadios(1).IPAddress;
    platform = connectedRadios(1).Platform;
end
connectedRadios(1)
%%
fc = 5.8e9; % in Hz
master_clock = 184.32e6; % USRP(X310): 184.32e6 or 200e6(default)

% Tx data load
load Waveform_OFDM_sym64_bw20.mat

tx_data=tx_sym;
zero_padding = 1024; % FFT point
waveform = [zeros(zero_padding,1); tx_data;];

% Decimation factor for the SDRu transmitter, specified as an integer 
% from 1 to 512(max) with restrictions, based on the radio you use. 
Deci_factor = 6;

Rx_sig_len = 375000 / 2;

% System object (Rx)
% This system object receives signal and control data from a USRP board 
% using the Universal Hardware Driver (UHD¢â) from Ettus Research.
radio_rx = comm.SDRuReceiver(...
    'Platform',             platform, ...
    'IPAddress',            address, ...
    'MasterClockRate',      master_clock, ...
    'CenterFrequency',      fc, ...
    'LocalOscillatorOffset',0,...
    'ChannelMapping',       [1 2], ... % % 1 -> RF A channel(Rx_signal), 2 -> RF B channel(Trigger)
    'ClockSource',          'External',... % 10MHz
    'Gain',                 [35 1] , ... % max AGC gain
    'DecimationFactor',     Deci_factor, ...
    'SamplesPerFrame',      Rx_sig_len, ...
    'OutputDataType',       'double');
% radio_rx.EnableBurstMode = true;
% radio_rx.NumFramesInBurst = 1;

n = 0;
Num = 100;
total_rx_sig = zeros(Rx_sig_len,2,Num);
tmp=0;
while n < Num
    [rx_sig, dataLen, overrun] = radio_rx(); % Receive signal and control data from USRP
    if dataLen > 0
        total_rx_sig(:,:,n+1) = rx_sig;
%         radar_func(rx_sig)
        n=n+1;
        if tmp==0&&n==1
           tmp=1; 
        end
    end
end
save rx_field_speed_v3.mat total_rx_sig -v7.3
% Release resources and allow changes to system object property values and input characteristics.
release(radio_rx);

%% figure
close all;

for a=1%:Num
    
    a1 = total_rx_sig(:,1,a);
    a2 = total_rx_sig(:,2,a);
    hold off;
    fig1=figure(a); plot(abs(a1));hold on;plot(abs(a2));
    grid on;
    axis([0 Rx_sig_len 0 1.4]);
    
    fig2=figure(2); plot(abs(a1/max(a1)),'-o');hold on;plot(abs(a2/max(a2)),'-o');
    grid on;
    axis([0 Rx_sig_len 0 1]);
    
    Fs = master_clock/1e6/Deci_factor(loop);
    
    hold off;
    fig3=figure(3);
    [pxx, f] = pwelch(a1, hanning(512), 256, 8192, Fs,'centered','power');
    plot(f,10*log10(pxx),'LineWidth',1.5);
    xlabel('frequency (MHz)'); ylabel('power spectral density (dB)');
    axis([-Fs/2 Fs/2 -90 -20]); grid on;
    hold on
    [pxx, f] = pwelch(a2, hanning(512), 256, 8192, Fs,'centered','power');
    plot(f,10*log10(pxx),'LineWidth',1.5);
    xlabel('frequency (MHz)'); ylabel('power spectral density (dB)');
    axis([-Fs/2 Fs/2 -90 -20]); grid on;
    
%     set([fig1],'OuterPosition',[0,550,700,450]);
%     set([fig2],'OuterPosition',[0,550,700,450]);
%     set([fig3],'OuterPosition',[0,80,480,450]);
end

rx_sig_ = total_rx_sig(:,:,1);
a = a1/max(a1);
b = a2/max(a2);
rx_sig_delay = [a b];
save test_sig_delay_2.mat rx_sig_ rx_sig_delay