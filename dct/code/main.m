N = 8;
basis = DCT_BS(N);
% task1: impement DCT on 1*8 vector.
%        at the end, it will check if the result is
%        the same as dct() provided by matlab
x = rand(N, 1);
x_dct = zeros(size(x));
% DCT
for i=1:N
    x_dct(i) = basis(i,:) * x;
end
sysdct = dct(x);
if misequal(x_dct, sysdct, 10e-12)
    disp('task1: dct is correct')
else
    disp('task1: dct is wrong')
end
% plot((1:N), x_dct, (1:N), sysdct, '*');
% legend('my implentation of DCT', 'Matlab DCT');
% task2: implement DCT & invert DCT on 1*8k(k=1,2,...) vector

n = 80;
cnt = n / N;
y = (1:n) + 50*cos((1:n)*2*pi/40);
y_dct = DCT_mine(y, basis);
y_idct = zeros(1, n);
% invert DCT
% N is size of one batch, which is 8
% cnt is the number of batches
for j=1:cnt
    for i=1:N
        y_idct((j-1) * N + 1:j * N) = y_idct((j-1) * N + 1:j * N) + y_dct(i + (j-1) * N) *  basis(i,:);
    end
end
%check if after DCT & iDCT, the signal is the same as original one
if misequal(y, y_idct, 10e-12)
    disp('task2: tranform is correct')
else
    disp('task2: tranform is wrong')
end

noise = 5*randn(1,n);
z = 50 * sin((1:n)*2*pi/40) + noise; % z is sin() with noise
z_dct = dct(z);
% preseve 20% of the dct, setting the rest to 0
cutoff_ratio = 0.2;
cutoff = floor(cutoff_ratio * n);
z_dct(1, cutoff:n) = 0;
z_idct = idct(z_dct);

plot((1:n), z_idct, (1:n), z, '--', (1:n), 50 * sin((1:n)*2*pi/40), '+');
legend('after dct', 'signal with noise', 'original signal');


        





