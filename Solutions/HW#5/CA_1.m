clc
close all
dp=0.01;
ds=0.01;
NID = 894;
fp=0.375 - NID * 1e-4;
fs=0.475 + NID * 1e-4;
Fsampl=2;
[nfir_ord,fr_edge,des_mag,wt] = firpmord( [fp fs], [1 0], [dp ds], Fsampl);
hfir= firpm(nfir_ord,fr_edge,des_mag,wt);
[Hfir,w]=freqz(hfir,1,201);
figure;
plot(w/pi,abs(Hfir));
xlabel('w/pi')
ylabel('Magnitude H(e^jw)')
title('Magnitude response of the FIR filter')
disp('Estimated filter order:')
disp(nfir_ord)
%label axes in plot, put title, etc.
MAX_DEV = zeros(1,2);
for i = 1:2
    band_start = round(fr_edge(2*i - 1) * 201) + 1;
    band_end = round(fr_edge(2*i) * 201);
    MAX_DEV(i) = max(abs(abs(Hfir(band_start:band_end)) - des_mag(2*i-1)));
end

disp('Maximum deviation for passband:')
disp(MAX_DEV(1))
disp('Maximum deviation for stopband:')
disp(MAX_DEV(2))