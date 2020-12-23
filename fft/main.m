N = 16;

x = round(10*rand(N,1));


% dft-real
%-----------
[cb, sb] = fft_base_real(N);

% cb, sb denotes cosine basis and sine basis
ReX = cb * x;
ImX = sb * x;


% idft-real
%----------------
% adjust parametr
Re = ReX / (N / 2);
Im = ImX / (N / 2);
Re(1) = ReX(1) / N;
Re(N/2+1) = ReX(N/2+1) / N;
% idft
y = cb' * Re + sb' * Im;


%dft-complex
comp_basis = fft_base_complex(N);
x_cdft = comp_basis * x;

%idft - complex
y_comp = comp_basis' * x_cdft / N;


% denoise
%--------------
frequency = [20];
fs = 1023;
n = fs + 1;
t = 0:1/fs:1;
signal = zeros(1, n);
for i=1:size(frequency, 2)
    %generate original signal
    signal = signal + 50 * cos(2*pi*frequency(i)*t);
end
signal = signal';
noise = 10 * rand(size(signal));
signal_noise = signal + noise; % signal w/ noise

% first do fft and show the signal in freqency domain
comp_basis = fft_base_complex(n);
signal_fft = comp_basis * signal_noise;
signal_fft_shift = fftshift(signal_fft);
f = (0:fs)*fs/n - fs / 2;
plot(f, abs(signal_fft_shift));

[cb, sb] = fft_base_real(n);
ReSig = cb * signal_noise;
ImSig = sb * signal_noise;

% do dft in real domain & denoise
ReSig(53:513) = 0;
ImSig(53:513) = 0;
ReS = ReSig / (n / 2);
ImS = ImSig / (n / 2);
ReS(1) = ReSig(1) / n;
ReS(n/2 + 1) = ReSig(n/2 + 1) / n;

% idft
signal_denoise = cb' * ReS + sb' * ImS;

x_axis = 0:1:fs;
figure;
% plot the result
plot(x_axis, signal, x_axis, signal_denoise, x_axis, signal_noise);
legend('orginal signal', 'signal after denoising', 'signal w/ noise');


% idft

