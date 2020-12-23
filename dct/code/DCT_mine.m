function sig_dct = DCT_mine(sig, basis)
% do DCT using provided basis elemen
N = size(basis, 1); % divide signal into batches size 8
sig_sz = size(sig);
% convert 1*n vector into n*1
if sig_sz(1) == 1
    sig = sig';
end
% n is signal numbers
n = size(sig, 1);
% cnt is number of batches
cnt = n / N;
sig_dct = zeros(n, 1);
for j=1:cnt
    for i=1:N
        sig_dct(i + (j-1) * N) = basis(i,:) * sig((j-1) * N + 1:j * N);
    end
end
end

