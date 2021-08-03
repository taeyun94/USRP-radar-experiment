function [resp,rng_grid,dop_grid] = helperRangeDoppler()
% This function is only in support of CFARDetectionExample. It may be
% removed in a future release.

%   Copyright 2016 The MathWorks, Inc.

load RangeDopplerExampleData;
hrdresp = phased.RangeDopplerResponse(...
    'DopplerFFTLengthSource','Property',...
    'DopplerFFTLength',RangeDopplerEx_MF_NFFTDOP,...
    'SampleRate',RangeDopplerEx_MF_Fs);
[resp,rng_grid,dop_grid] = step(hrdresp,...
     RangeDopplerEx_MF_X,RangeDopplerEx_MF_Coeff);

% Add white noise
rs = RandStream('mt19937ar','Seed',1);
npow = db2mag(-95);
resp = resp + npow/sqrt(2)*(randn(rs,size(resp)) + 1i*randn(rs,size(resp)));

figure
%surf(dop_grid,rng_grid,mag2db(abs(resp)),'edgecolor','none');
h = imagesc(dop_grid,rng_grid,mag2db(abs(resp)));
xlabel('Doppler (Hz)'); ylabel('Range (m)'); title('Range Doppler Map');
h.Parent.YDir = 'normal';
resp = abs(resp).^2;