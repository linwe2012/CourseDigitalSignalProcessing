function basis = DCT2_BS(N)
basis = zeros(N,N);
for i=1:N
    for j = 1:N
        basis(i,j) = cos(pi*(2*j-1)*(i-1)/(2*N));
    end;
end;

basis(1,:) = basis(1,:) / sqrt(N);
for i = 2:N
    basis(i,:) = basis(i,:) * sqrt(2 / N);
end
end


