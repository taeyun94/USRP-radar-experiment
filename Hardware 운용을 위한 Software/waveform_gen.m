function waveform = wav_gen(over_s)

N = 1024;

data = randi([0 1],N,1);
sym = [zeros(1024,1); 2*data-1; zeros(1024,1)];

sym_o = zeros(length(sym)*over_s,1);
sym_o(1:over_s:end) = sym;

psf = rcosdesign(0.5, 10, over_s, 'normal');
waveform = conv(sym_o,psf);

