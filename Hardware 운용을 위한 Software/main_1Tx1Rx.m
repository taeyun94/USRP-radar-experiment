% Ettus Research USRP B210 test (1Tx - 1Rx)
% Development Environment : Windows 10, Matlab R2020a

% clear;
% "findsdru" Find and report status for all USRP(B210) devices connected to host computer.
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

fc = 915e6; % in Hz
usrp_gain = 25; % in dB
master_clock = 61.44e6; % USRP(B210): From 5e6 Hz to 56e6 Hz.
sym_clk = master_clock/100;
over_s = 10;
waveform = wav_gen(over_s);
intp_factor = master_clock/sym_clk/over_s;

% System object (Tx)
% This system object accepts a column vector or matrix input signal from MATLAB 
% and transmits signal and control data to a USRP board using 
% the Universal Hardware Driver (UHD¢â) from Ettus Research.
radio_tx = comm.SDRuTransmitter(...
    'Platform',             platform, ...
    'SerialNum',            address, ...
    'MasterClockRate',      master_clock, ...
    'ChannelMapping',      1, ...
    'CenterFrequency',      fc, ...
    'Gain',                 usrp_gain, ...
    'InterpolationFactor',  intp_factor);
% radio_tx.EnableBurstMode = true;
% radio_tx.NumFramesInBurst = 1;

% System object (Rx)
% This system object receives signal and control data from a USRP board 
% using the Universal Hardware Driver (UHD¢â) from Ettus Research.
radio_rx = comm.SDRuReceiver(...
    'Platform',             platform, ...
    'SerialNum',            address, ...
    'MasterClockRate',      master_clock, ...
    'CenterFrequency',      fc, ...
    'ChannelMapping',       1, ...
    'Gain',                 31, ... % max AGC gain
    'DecimationFactor',     intp_factor, ...
    'SamplesPerFrame',    length(waveform), ...
    'OutputDataType',       'double');
% radio_rx.EnableBurstMode = true;
% radio_rx.NumFramesInBurst = 1;

num = 100;
rx_sig = zeros(length(waveform),num);

for n=1:num
    underrun  = step(radio_tx, waveform); % Transmit signal and control data to USRP
    [rx_sig(:,n), dataLen, overrun] = step(radio_rx); % Receive signal and control data from USRP
end

% Release resources and allow changes to system object property values and input characteristics.
release(radio_tx);
release(radio_rx);

%% figure
close all;

Fs = master_clock/1e6/intp_factor;

fig1=figure(1);
plot(abs(rx_sig(:,1)));

fig2=figure(2);
[pxx, f] = pwelch(rx_sig(:,1), hanning(512), 256, 8192, Fs,'centered','power');
plot(f,10*log10(pxx),'b','LineWidth',1.5);
xlabel('frequency (MHz)'); ylabel('power spectral density (dB)');
% axis([-Fs/2 Fs/2 -58 0]);
grid on;

fig3=figure(3);
for q=1:num
    plot(abs(rx_sig(:,q))); hold on;
end

