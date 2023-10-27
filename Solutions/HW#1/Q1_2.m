clf;
NID = input('Type in N_ID = ');
fp=0.31+0.14*NID/1000;
fs=1-fp;
Nord=10;% choose even order
h = firpm(Nord, [0 fp fs 1], [1 1 0 0], [1 1]);
h_shifted = circshift(h, -n_shift);

figure(1)
stem(0-floor(Nord/2):Nord - floor(Nord/2), h)
xlabel('n');ylabel('h_shifted');
title('After shifting');


[H, w] = freqz(h,1,100);
figure(2)
plot(w, abs(H));%Plot the magnitude response of filter
xlabel('frequency');ylabel('DFT magnitude');
title('Magnitude of H versus frequency ');
axis([0 pi 0 1.2*max(abs(H))]);
grid;
disp('PRESS RETURN for pole-zero plot of H');

figure(3)
plot(w, phase(H));%Plot the magnitude response of filter
xlabel('frequency');ylabel('DFT phase');
title('Phase of H versus frequency ');
axis([0 pi -10 10]);
grid;
disp('PRESS RETURN for pole-zero plot of H');

%pause
figure(4)
roots(h)
zplane(h);

