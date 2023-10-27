% Define the sequences x[n] and h[n]
n = 0:15;
x = (n + 3) .* (heaviside(n) - heaviside(n - 15));
h = heaviside(n) - heaviside(n - 5);

% Compute the 16-point DFTs
X16 = fft(x, 16)
H16 = fft(h, 16)
Y16 = X16 .* H16;
y16 = ifft(Y16, 16)

% Compute the 32-point DFTs
X32 = fft(x, 32);
H32 = fft(h, 32);
Y32 = X32 .* H32;
y32 = ifft(Y32, 32)

figure(1)
subplot(3,1,1)
stem(y16)
title('16-points IDFT')
subplot(3,1,2)
stem(y32)
title('32-points IDFT')
subplot(3,1,3)
stem(conv(x, h))
stem(y32)
title('Linear conv of x and h')



