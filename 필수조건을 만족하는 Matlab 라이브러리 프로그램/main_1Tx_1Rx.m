% Ettus Research USRP X310 test (1Tx - 1Rx)
% Development Environment : Windows 10, Matlab R2020a

clc
connectedRadios = findsdru;
if strncmp(connectedRadios(1).Status, 'Success', 7)
    switch connectedRadios(1).Platform
        case {'B200','B210'}
            address = connectedRadios(1).SerialNum;
            platform = connectedRadios(1).Platform;
        case {'N200/N210/USRP2'}
            address = connectedRadios(1).IPAddress;
            platform = 'N200/N210/USRP2';
        case {'X300','X310'}
            platform = connectedRadios(1).Platform;
            address = connectedRadios(1).IPAddress;
    end
end
connectedRadios

fc = 5.8e9; % in Hz
usrp_gain = 30; % in dB
master_clock = 184.32e6; % USRP(X310): 184.32e6 or 200e6(default)
SamplesPerFrame = 375000 / 2; 

% Tx data load
load Waveform_OFDM_sym64_bw20.mat

tx_data = tx_sym;
zero_padding = 1024; % FFT point
waveform = [zeros(zero_padding,1); tx_data;];
intp_factor = [6:6:60,128,256,512];

for loop=1:length(intp_factor)
    disp(intp_factor(loop));
    
    if (loop ~= 1)
        release(radio_tx);
        release(radio_rx);
    end
 
    radio_tx = comm.SDRuTransmitter(...
        'Platform',             platform, ...
        'IPAddress',            address, ...
        'MasterClockRate',      master_clock, ...
        'ChannelMapping',       1, ... % RF A channel 
        'CenterFrequency',      fc, ...
        'LocalOscillatorOffset',0,...
        'Gain',                 usrp_gain, ...
        'InterpolationFactor',  intp_factor(loop));
    radio_tx.TransportDataType = 'int16';
    
    radio_rx = comm.SDRuReceiver(...
        'Platform',             platform, ...
        'IPAddress',            address, ...
        'MasterClockRate',      master_clock, ...
        'CenterFrequency',      fc, ...
        'LocalOscillatorOffset',0,...
        'ChannelMapping',       2, ... % RF B channel 
        'Gain',                 1, ... % max AGC gain
        'DecimationFactor',     intp_factor(loop), ...
        'SamplesPerFrame',    SamplesPerFrame, ...
        'OutputDataType',       'double');
    radio_rx.TransportDataType = 'int16';
    
    n = 0;
    Num = 100;
    total_rx_sig = zeros(SamplesPerFrame, Num);
    
    while n < Num
        underrun  = step(radio_tx, waveform); % Transmit signal and control data to USRP
        
        [rx_sig, dataLen, overrun] = radio_rx(); % Receive signal and control data from USRP
        if dataLen > 0
            total_rx_sig(:,n+1) = rx_sig;
            n=n+1;
        end
    end
    
    % Release resources and allow changes to system object property values and input characteristics.
    release(radio_tx);
    release(radio_rx);
    
    % Figure gen
    close all;
    
    a = total_rx_sig(:,1);
    
    fig1=figure(1); plot(abs(a));
    axis([0 SamplesPerFrame 0 1]);
    grid on;
    
    Fs = master_clock/1e6/intp_factor(loop);
    
    fig2=figure(2);
    [pxx, f] = pwelch(a, hanning(512), 256, 8192, Fs,'centered','power');
    plot(f,10*log10(pxx),'b','LineWidth',1.5);
    xlabel('frequency (MHz)'); ylabel('power spectral density (dB)');
    % axis([-Fs/2 Fs/2 min(10*log10(pxx)) max(10*log10(pxx))]);
    axis([-Fs/2 Fs/2 -70 -20]);
    grid on;
    
    fig3=figure(3);
    for q =1:10
        plot(abs(total_rx_sig(:,q))); hold on;
    end
    grid on;
    axis([0 SamplesPerFrame 0 1]);
    set([fig1,fig3,fig6],'OuterPosition',[0,500,480,450]);
    
%     S1 = sprintf('./Time_domain_1Tx1Rx_1_intp_%d', intp_factor(loop));
%     S2 = sprintf('./Spectrum_domain_1Tx1Rx_intp_%d', intp_factor(loop));
%     S3 = sprintf('./Time_domain_1Tx1Rx_10_intp_%d', intp_factor(loop));
    
%     saveas(fig1, S1); saveas(fig2, S2); saveas(fig3, S3); % figure save
end