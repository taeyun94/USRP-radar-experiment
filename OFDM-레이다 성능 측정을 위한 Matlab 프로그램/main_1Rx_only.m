% Ettus Research USRP X310 test, 1Tx(Signal generator) 1Rx(X310)
% Development Environment : Windows 10, Matlab R2020a

% clear;
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
master_clock = 184.32e6; % USRP(X310): 184.32e6 or 200e6(default)
Deci_factor = 6;
SamplesPerFrame = 175000;

% System object (Rx)
% This system object receives signal and control data from a USRP board 
% using the Universal Hardware Driver (UHD¢â) from Ettus Research.
radio_rx = comm.SDRuReceiver(...
    'Platform',             platform, ...
    'IPAddress',            address, ...
    'MasterClockRate',      master_clock, ...
    'CenterFrequency',      fc, ...
    'ChannelMapping',       1, ...
    'Gain',                 1, ... % max AGC gain
    'DecimationFactor',     Deci_factor, ...
    'SamplesPerFrame',      SamplesPerFrame, ...
    'OutputDataType',      'double');
% radio_rx.EnableBurstMode = true;
% radio_rx.NumFramesInBurst = 10;

n = 0;
Num = 100;
rx_sig = zeros(SamplesPerFrame, Num);

while n < Num 
    [temp, dataLen, overrun] = step(radio_rx); % Receive signal and control data from USRP
    
    if dataLen > 0
        rx_sig(:, n+1)=temp;
        n = n + 1;
    end
end

% Release resources and allow changes to system object property values and input characteristics.
release(radio_rx);

%% figure
close all

index = 1;

fig1=figure(1); 
plot(abs(rx_sig(:,index)));

Fs = master_clock/1e6/Deci_factor;

fig3=figure(3);
[pxx, f] = pwelch(rx_sig(:,index), hanning(512), 256, 8192, Fs,'centered','power');
plot(f,10*log10(pxx),'b','LineWidth',1.5);
xlabel('frequency (MHz)'); ylabel('power spectral density (dB)');
% axis([-Fs/2 Fs/2 -90 0]);
grid on;

fig6=figure(6);
for q=1:10
    plot(abs(rx_sig(:,q))); hold on;
end

% set([fig1,fig3,fig6],'OuterPosition',[0,500,480,450]);