function pcm_d = dpcm_decode( data )
d_size = size(data);
if d_size(2) == 1
    data = data';
end
d_size = size(data);
cnt = d_size(2);
pcm_d = zeros(1, cnt);
pcm_d(1) = data(1);
pcm_d(2) = data(2) + data(1);
for i=3:cnt
    project = floor(0.5 * (pcm_d(i-2) + pcm_d(i-1)));
    pcm_d(i) = project + data(i);
end
end
