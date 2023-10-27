% Plab1_1.m Generation of sum of two sinusoidal sequences
% Plotting the DFT and DTFT
clf;
NID = input('Type in N_ID = ');
w1 = 0.08 * pi + 0.3 * NID * pi/1000;
w2 = pi - w1;
disp('Frequency w1 = '), disp(w1);
disp('Frequency w2 = '), disp(w2);
Nsamples = 101;
n = 1:Nsamples;
%nt=101;
x = 2*cos(w1*n) + cos(w2*n);

Xfft = fft(x);
Xmax1 = max(abs(Xfft));
w = (n-1)*2*pi/Nsamples;
[Xdtft, wgrid] = freqz(x,1,Nsamples);
Xmax2 = max(abs(Xdtft));
figure(1)
stem(n-1, x(n));
xlabel('Sample number n');ylabel('Signal value x');
axis([0 Nsamples -2 2]);
grid;
title('Sum of sinusoids');
disp('PRESS RETURN for magnitude of DFT and DTFT of x');
%pause
Xdirect = zeros(1,Nsamples);%direct computation of DTFT at Nsamples points
for k=1:Nsamples
    tem1 = exp(1i*pi*(n-1)*(k-1)/Nsamples);
    Xdirect(k) = sum(x.*tem1);
end
w = (n-1)*pi/Nsamples;
figure(2) 
plot(w,abs(Xdirect));
xlabel('frequency \omega');ylabel('DTFT magnitude');
title('Directly computed DTFT versus frequency \omega');
pause
figure(3)
subplot(3,1,1)
stem(n-1, abs(Xfft));%Plot the magnitude of DFTof x
xlabel('frequency index k');ylabel('DFT magnitude');
axis([0 Nsamples-1 0 1.2*Xmax1]);
grid;
title('DFT versus index k');
subplot(3,1,2)
stem(w, abs(Xfft));%Plot the magnitude of DFTof x
xlabel('frequency');ylabel('DFT magnitude');
title('DFT versus discretized frequency \omega');
axis([0 2*pi*(Nsamples-1)/Nsamples 0 1.2*Xmax1]);
grid;
subplot(3,1,3)
plot(wgrid, abs(Xdtft));%Plot the magnitude of DTFTof x
xlabel('frequency \omega');ylabel('DTFT magnitude');
title('DTFT versus frequency \omega');
axis([0 2*pi*(Nsamples-1)/Nsamples 0 1.2*Xmax1]);
grid;


