function pcm_e = pcm_encode( cnt, data )
pcm_e = zeros(1, cnt);
pcm_e(1) = data(1);
pcm_e(2) = data(2) - data(1);
for i=3:cnt
    project = floor(0.5 * (data(i-2) + data(i-1)));
    pcm_e(i) = data(i) - project;
end
end

