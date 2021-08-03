% Ettus Research USRP X310 test (1Tx - 1Rx)
% Development Environment : Windows 10, Matlab R2020a

% clear;
% "findsdru" Find and report status for all USRP(X310) devices connected to host computer.
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
            address = connectedRadios(1).IPAddress;
            platform = connectedRadios(1).Platform;
    end
end
connectedRadios

fc = 5.8e9; % in Hz
usrp_gain = 31; % in dB
master_clock = 184.32e6; % USRP(X310): 184.32e6 or 200e6(default)

% Tx data load
load Waveform_WLAN.mat

zero_padding = length(tx_data);
waveform = [zeros(zero_padding,1); tx_data;];

% Interpolation factor for the SDRu transmitter, specified as an integer 
% from 1 to 512(max) with restrictions, based on the radio you use. 
intp_factor = 6;  % Ex) Masterclock 184.32MHz, InterpolationFactor 6 >> Sampling clock=30.72MHz

% System object (Tx)
% This system object accepts a column vector or matrix input signal from MATLAB 
% and transmits signal and control data to a USRP board using 
% the Universal Hardware Driver (UHD¢â) from Ettus Research.
radio_tx = comm.SDRuTransmitter(...
    'Platform',             platform, ...
    'IPAddress',            address, ...
    'MasterClockRate',      master_clock, ...
    'ChannelMapping',       1, ...  % RF A channel 
    'CenterFrequency',      fc, ...
    'LocalOscillatorOffset',0,...
    'Gain',                 usrp_gain, ...
    'InterpolationFactor',  intp_factor, ...
    'TransportDataType',  'int16');
% radio_tx.EnableBurstMode = true;
% radio_tx.NumFramesInBurst = 1;

% System object (Rx)
% This system object receives signal and control data from a USRP board 
% using the Universal Hardware Driver (UHD¢â) from Ettus Research.
radio_rx = comm.SDRuReceiver(...
    'Platform',             platform, ...
    'IPAddress',            address, ...
    'MasterClockRate',      master_clock, ...
    'CenterFrequency',      fc, ...
    'LocalOscillatorOffset',0,...
    'ChannelMapping',       1, ...
    'Gain',                 1, ... % max AGC gain
    'DecimationFactor',     intp_factor, ...
    'SamplesPerFrame',    length(waveform), ...
    'OutputDataType',       'double', ...
    'TransportDataType',  'int16');
% radio_rx.EnableBurstMode = true;
% radio_rx.NumFramesInBurst = 1;

n = 0;
Num = 100;
total_rx_sig = zeros(length(waveform), Num);

underrun  = step(radio_tx, waveform);

while n < Num
    for iter = 1:1
        underrun  = step(radio_tx, waveform); % Transmit signal and control data to USRP
    end
    [rx_sig, dataLen, overrun] = step(radio_rx); % Receive signal and control data from USRP
    if dataLen > 0
        total_rx_sig(:,n+1) = rx_sig;
        n=n+1;
    end
end

% Release resources and allow changes to system object property values and input characteristics.
release(radio_tx);
release(radio_rx);

%% figure
close all;

Fs = master_clock/1e6/intp_factor;

a = total_rx_sig(:,1); b = total_rx_sig(:,2);

fig1=figure(1); plot(abs(a));
fig2=figure(2); plot(abs(b));
% axis([0 12000 0 0.018]);

fig3=figure(3);
[pxx, f] = pwelch(a, hanning(512), 256, 8192, Fs,'centered','power');
plot(f,10*log10(pxx),'b','LineWidth',1.5);
xlabel('frequency (MHz)'); ylabel('power spectral density (dB)');
% axis([-Fs/2 Fs/2 -95 0]);
grid on;

fig4=figure(4);
[pxx, f] = pwelch(b, hanning(512), 256, 8192, Fs,'centered','power');
plot(f,10*log10(pxx),'b','LineWidth',1.5);
xlabel('frequency (MHz)'); ylabel('power spectral density (dB)');
% axis([-Fs/2 Fs/2 -95 0]);
grid on;

fig5=figure(5);
for q =1:Num
    plot(abs(total_rx_sig(:,q))); hold on;
end
% axis([0 12000 0 0.018]);
% set([fig1,fig2,fig3,fig4,fig5],'OuterPosition',[0,500,480,450]);
