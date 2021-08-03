% Ettus Research USRP X310 test, 1Tx(Signal generator) 2Rx(X310)
% Development Environment : Windows 10, Matlab R2020a

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
%%
fc = 5.8e9; % in Hz
master_clock = 184.32e6; % USRP(X310): 184.32e6 or 200e6(default)
% Decimation factor for the SDRu transmitter, specified as an integer 
% from 1 to 512(max) with restrictions, based on the radio you use. 
Deci_factor = 6; 
SamplesPerFrame = 5120*2; % waveform len x 2 

% System object (Rx)
% This system object receives signal and control data from a USRP board 
% using the Universal Hardware Driver (UHD¢â) from Ettus Research.
radio_rx = comm.SDRuReceiver(...
    'Platform',             platform, ...
    'IPAddress',            address, ...
    'MasterClockRate',      master_clock, ...
    'CenterFrequency',      fc, ...
    'ChannelMapping',       [1 2], ... % 1 -> RF A channel, 2 -> RF B channel 
    'Gain',                 1, ... % max AGC gain
    'DecimationFactor',     Deci_factor, ...
    'SamplesPerFrame',      SamplesPerFrame, ...
    'OutputDataType',      'double');
% radio_rx.EnableBurstMode = true;
% radio_rx.NumFramesInBurst = 10;

n = 0;
Num = 100;
rx_sig = zeros(SamplesPerFrame, 2, Num);

while n < Num 
    [temp, dataLen, overrun] = step(radio_rx); % Receive signal and control data from USRP
    
    if dataLen > 0
        rx_sig(:,1, n+1)=temp(:,1);
        rx_sig(:,2, n+1)=temp(:,2);
        n = n + 1;
    end
end

% Release resources and allow changes to system object property values and input characteristics.
release(radio_rx);

%% figure
close all;

a = 1;

sig1 = rx_sig(:,1,a);
sig2 = rx_sig(:,2,a);

fig1=figure(1); 
plot(abs(sig1));
hold on;
plot(abs(sig2));

Fs = master_clock/1e6/Deci_factor;

fig2=figure(2);
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

fig3=figure(3);
for q=1:2
    plot(abs(rx_sig(:,q))/max(abs(rx_sig(:,q)))); hold on;
end 

% set([fig1,fig2,fig3],'OuterPosition',[0,500,480,450]);