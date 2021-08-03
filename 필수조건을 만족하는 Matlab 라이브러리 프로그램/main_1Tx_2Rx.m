% Ettus Research USRP X310 test (1Tx - 2Rx)
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
usrp_gain = 31; % in dB 
master_clock = 184.32e6; % USRP(X310): 184.32e6 or 200e6(default)
SamplesPerFrame = 375000 / 2; 

load Waveform_OFDM_sym64_bw20.mat

tx_data = tx_sym;

zero_padding = 1024; % FFT point
waveform = [zeros(zero_padding,1); tx_data;];

% intp_factor = [6:6:60,128,256,512];
intp_factor = 6;

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
        'TransportDataType',    'int16',...
        'InterpolationFactor',  intp_factor(loop));
    
    radio_rx = comm.SDRuReceiver(...
        'Platform',             platform, ...
        'IPAddress',            address, ...
        'MasterClockRate',      master_clock, ...
        'CenterFrequency',      fc, ...
        'LocalOscillatorOffset',0,...
        'ChannelMapping',       [1 2], ... % 1 -> RF A channel, 2 -> RF B channel 
        'Gain',                 1, ... % max AGC gain
        'DecimationFactor',     intp_factor(loop), ...
        'TransportDataType',    'int16',...
        'SamplesPerFrame',    SamplesPerFrame, ...
        'OutputDataType',       'double');
    
    n = 0;
    Num = 10;
    rx_sig = zeros(SamplesPerFrame, 2, Num);
    
    while n < Num
        underrun  = step(radio_tx, [waveform]); % Transmit signal and control data to USRP
        [temp, dataLen, overrun] = step(radio_rx); % Receive signal and control data from USRP
        
        if dataLen > 0
            rx_sig(:,1, n+1)=temp(:,1);
            rx_sig(:,2, n+1)=temp(:,2);
            n = n + 1;
        end
    end
    
    % Release resources and allow changes to system object property values and input characteristics.
    release(radio_tx);
    release(radio_rx);
    
    close all;
    
    a=1;
    a1 = rx_sig(:,1,a);
    a2 = rx_sig(:,2,a);
    
    fig1=figure(1); plot(abs(a1));hold on;plot(abs(a2));
    axis([0 SamplesPerFrame 0 0.6]);
    grid on;
    
    Fs = master_clock/1e6/intp_factor(loop);
    
    fig2=figure(2);
    [pxx, f] = pwelch(a1, hanning(512), 256, 8192, Fs,'centered','power');
    plot(f,10*log10(pxx),'LineWidth',1.5);
    xlabel('frequency (MHz)'); ylabel('power spectral density (dB)');
    axis([-Fs/2 Fs/2 -70 -20]);
    grid on;
    hold on
    [pxx, f] = pwelch(a2, hanning(512), 256, 8192, Fs,'centered','power');
    plot(f,10*log10(pxx),'LineWidth',1.5);
    xlabel('frequency (MHz)'); ylabel('power spectral density (dB)');
    axis([-Fs/2 Fs/2 -70 -20]);
    grid on;
    
    fig3=figure(3);
    for q =1:10
        plot(abs(total_rx_sig(:,q))); hold on;
    end
    
    set([fig1,fig2],'OuterPosition',[0,500,480,450]);
    
%     S1 = sprintf('./Time_domain_1Tx2Rx_1_intp_%d', intp_factor(loop));
%     S2 = sprintf('./Spectrum_domain_1Tx2Rx_intp_%d', intp_factor(loop));
%     S3 = sprintf('./Time_domain_1Tx2Rx_10_intp_%d', intp_factor(loop));
    
%     saveas(fig1, S1); saveas(fig2, S2); saveas(fig3, S3); % figure save;
end