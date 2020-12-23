function dpcm_d = dpcm_decode( cnt, data )
dpcm_d = zeros(1, cnt);
dpcm_d(1) = data(1);
dpcm_d(2) = data(2) + data(1);
for i=3:cnt
    project = floor(0.5 * (dpcm_d(i-2) + dpcm_d(i-1)));
    dpcm_d(i) = project + data(i);
end
end