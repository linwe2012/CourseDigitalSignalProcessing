function basis = fft_base_complex( N )
basis = zeros(N, N);
for j=0:N-1
    for k=0:N-1
        inside = 2 * pi * j * k / N;
        basis(j+1, k+1) = cos(inside) + sin(inside)*1i;
    end
    
end
end

