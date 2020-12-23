function [cosbasis, sinbasis] = fft_base_real( N )
cosbasis = zeros(N/2+1, N);
sinbasis = zeros(N/2+1, N);
for i=0:N/2
    for j=0:N-1
        cosbasis(i+1,j+1) = cos(2*pi*i*j / N);
        sinbasis(i+1,j+1) = sin(2*pi*i*j / N);
    end
end
end

