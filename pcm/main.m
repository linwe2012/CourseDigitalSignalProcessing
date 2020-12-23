%config
cnt = 50; %number of signals
sig_max = 255; %maximum signal range
%code
x = 1:1:cnt;
signal = randi(sig_max, [1, cnt]);
%encode & decode
pcm_e = pcm_encode(cnt, signal);
pcm_d = pcm_decode(cnt, pcm_e);
dpcm_e = dpcm_encode(cnt, signal);
dpcm_d = dpcm_decode(cnt, dpcm_e);

plot(x, signal, '*', x, pcm_d, x, dpcm_d, 'g');
legend('orginal sig', 'pcm', 'dpcm');