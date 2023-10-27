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
[nell_ord, wn] = ellipord(2*fp/Fsampl, 2*fs/Fsampl, -20*log10(1-dp), -20*log10(ds));% Filter order & parameter wn are computed.
[b_ell,a_ell] = ellip(nell_ord, -20*log10(1-dp), -20*log10(ds), wn);% Filter
[Hell,w]=freqz(b_ell,a_ell,501);% Frequency response is computed.
figure
plot(w/pi,abs(Hell));
%label axes in plot, put title, etc.
xlabel('w/pi')
ylabel('Magnitude H(e^jw)')
title('Magnitude response of the Elliptic lowpass filter')
disp('Estimated filter order:')
disp(nell_ord)

MAX_DEV = zeros(1,2);
for i = 1:2
    band_start = round(fr_edge(2*i-1) * 501) + 1;
    band_end = round(fr_edge(2*i) * 501);
    %median(abs(abs(Hbut(band_start:band_end)) - des_mag(i)))
    MAX_DEV(i) = max(abs(abs(Hell(band_start:band_end)) - des_mag(i)));
end


disp('Maximum deviation for passband:')
disp(MAX_DEV(1))
disp('Maximum deviation for stopband:')
disp(MAX_DEV(2))
