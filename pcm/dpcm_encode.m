function dpcm_e = dpcm_encode( cnt,  data )
dpcm_e = zeros(1, cnt);
prev1 = data(1);
dpcm_e(1) = prev1;
e = data(2) - prev1;
dpcm_e(2) = 16*floor((255+e)/16)-256+8;
prev2 = prev1 + dpcm_e(2);
for i=3:cnt
    project = floor((prev1 + prev2) * 0.5);
    prev1 = prev2;
    e = data(i) - project;
    dpcm_e(i) = 16*floor((255+e)/16)-256+8;
    prev2 = project + dpcm_e(i);
end
end 
