% Ettus Research USRP B210 test (1Tx - 2Rx)
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
% the Universal Hardware Driver (UHD™) from Ettus Research.
radio_tx = comm.SDRuTransmitter(...
    'Platform',             platform, ...
    'SerialNum',            address, ...
    'MasterClockRate',      master_clock, ...
    'ChannelMapping',      [1 2], ... % 
    'CenterFrequency',      fc, ...
    'Gain',                 usrp_gain, ...
    'InterpolationFactor',  intp_factor);
% radio_tx.EnableBurstMode = true;
% radio_tx.NumFramesInBurst = 1;

% System object (Rx)
% This system object receives signal and control data from a USRP board 
% using the Universal Hardware Driver (UHD™) from Ettus Research.
radio_rx = comm.SDRuReceiver(...
    'Platform',             platform, ...
    'SerialNum',            address, ...
    'MasterClockRate',      master_clock, ...
    'CenterFrequency',      fc, ...
    'ChannelMapping',       [1 2], ...
    'Gain',                      [31 31], ... % max AGC gain
    'DecimationFactor',     intp_factor, ...
    'SamplesPerFrame',    length(waveform), ...
    'OutputDataType',       'double');
% radio_rx.EnableBurstMode = true;
% radio_rx.NumFramesInBurst = 1;

n = 0;
Num = 100;
total_rx_sig = zeros(length(waveform), Num*2);

while n < Num % 100 samples
    underrun  = step(radio_tx, [waveform waveform]); % Transmit signal and control data to USRP
    [rx_sig, dataLen, overrun] = step(radio_rx); % Receive signal and control data from USRP
    if dataLen > 0
        total_rx_sig(:,2*n+1:2*n+2) = rx_sig;
        n = n + 1;
    end
end

% Release resources and allow changes to system object property values and input characteristics.
release(radio_tx);
release(radio_rx);

disp("1Tx -> 1Rx end");
if underrun > 0
    disp("underrun(tx) 발생");
end
if overrun > 0
    disp("overrun(rx) 발생");
end
%% figure
close all;

a = total_rx_sig(:,1);
b = total_rx_sig(:,2);

fig1=figure(1); plot(abs(a));
fig2=figure(2); plot(abs(b));

Fs = master_clock/1e6/intp_factor;

Fs = master_clock/1e6/intp_factor;
fig3=figure(3);
[pxx, f] = pwelch(sig1, hanning(512), 256, 8192, Fs,'centered','power');
plot(f,10*log10(pxx),'LineWidth',1.5);
xlabel('frequency (MHz)'); ylabel('power spectral density (dB)');
% axis([-Fs/2 Fs/2 -90 0]);
grid on;
hold on
[pxx, f] = pwelch(sig2, hanning(512), 256, 8192, Fs,'centered','power');
plot(f,10*log10(pxx),'LineWidth',1.5);
xlabel('frequency (MHz)'); ylabel('power spectral density (dB)');
% axis([-Fs/2 Fs/2 -90 0]);
grid on;

