% Ettus Research USRP X310 test, 1Tx(X310) 1Rx(Digital oscilloscope)
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
%% figure
fc = 5.8e9; % in Hz
usrp_gain = 31; % in dB 
master_clock = 184.32e6; % USRP(X310): 184.32e6 or 200e6(default)

% Tx data load
load Waveform_WLAN.mat

zero_padding = length(tx_data)*5;
waveform = [zeros(zero_padding,1); tx_data;];
intp_factor = 6; % 1 ~ 512(max)

radio_tx = comm.SDRuTransmitter(...
    'Platform',             platform, ...
    'IPAddress',            address, ...
    'MasterClockRate',      master_clock, ...
    'ChannelMapping',       1, ...
    'CenterFrequency',      fc, ...
    'LocalOscillatorOffset',0,... 
    'Gain',                 usrp_gain, ...
    'InterpolationFactor',  intp_factor);
% radio_tx.EnableBurstMode = true;
% radio_tx.NumFramesInBurst = 100;

n=0;
while(1)
%     for iter=1:100
    underrun  = step(radio_tx, waveform); % Transmit signal and control data to USRP
    n=n+1;
end

release(radio_tx);


