N=64;
n = [1:N];
alpha= 10;
% x = exp(2j*pi*(n-1)*alpha/N); % We use (n-1) to start the index at 0
x = 2 * cos (2*pi*(n-1)*alpha/N);
X = fft(x,N);
figure(1)
stem(n-1,real(X));
title('Real value DFT')
figure(2)
stem(n-1,imag(X));
title('Imaginary DFT')