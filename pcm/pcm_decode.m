function pcm_d = pcm_decode( cnt, data )
pcm_d = zeros(1, cnt);
pcm_d(1) = data(1);
pcm_d(2) = data(2) + data(1);
for i=3:cnt
    project = floor(0.5 * (pcm_d(i-2) + pcm_d(i-1)));
    pcm_d(i) = project + data(i);
end
end
