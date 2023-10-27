clc
close all
dp=0.01;
ds=0.01;
NID = 894;
fp=0.375 - NID * 1e-4;
fs=0.475 + NID * 1e-4;
Fsampl=2;
fr_edge = [0 2*fp/Fsampl, 2*fs/Fsampl 1];
des_mag = [1, 0];
[nbut_ord, wn] = buttord(2*fp/Fsampl, 2*fs/Fsampl,-20*log10(1-dp), -20*log10(ds));% Filter order & parameter wn are computed.
[b_but,a_but] = butter(nbut_ord, wn);% Filter coefficients are computed.
[Hbut,w]=freqz(b_but,a_but,501);% Frequency response is computed.
figure;
plot(w/pi,abs(Hbut));% Magnitude response vs. omega/pi
xlabel('w/pi')
ylabel('Magnitude H(e^jw)')
title('Magnitude response of the Butterworth filter')
disp('Estimated filter order:')
disp(nbut_ord)
%label axes in plot, put title, etc.
MAX_DEV = zeros(1,2);
for i = 1:2
    band_start = round(fr_edge(2*i-1) * 501) + 1;
    band_end = round(fr_edge(2*i) * 501);
    %median(abs(abs(Hbut(band_start:band_end)) - des_mag(i)))
    MAX_DEV(i) = max(abs(abs(Hbut(band_start:band_end)) - des_mag(i)));
end

disp('maximum deviation for stopband happens at stopband normalized frequncy that is equal to:')
disp(fr_edge(2))
disp('maximum deviation for passband happens at passband normalized frequncy that is equal to:')
disp(fr_edge(3))
disp('Maximum deviation for passband:')
disp(MAX_DEV(1))
disp('Maximum deviation for stopband:')
disp(MAX_DEV(2))