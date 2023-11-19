%% Loading
clc
close all
load('tones.mat')
load('telephone_numbers.mat')
%% Effect of padding & cutting signal on fourier Transform
clc
close all
digit_signal = eval(['u', num2str(0)]);
Shifted = [digit_signal;zeros(1024,1)];
double_shifted = [digit_signal(1:50);zeros(206,1)];
pnts = length(digit_signal);
pnts_shifted = length(Shifted);
spectrum = abs(fft(digit_signal)/pnts);
spectrum_shifted = abs(fft(Shifted)/pnts_shifted);
spectrum_Dshifted = abs(fft(double_shifted)/pnts);
hz = linspace(0,Fs/2,floor(pnts/2)+1);
hz_shifted = linspace(0,Fs/2,floor(pnts_shifted/2)+1);
figure;
hold on 
stem(hz, spectrum(1:length(hz)),'ko-','linew',2,'markersize',6,'markerfacecolor','k')
stem(hz_shifted, spectrum_shifted(1:length(hz_shifted)),'bo-','linew',2,'markersize',6,'markerfacecolor','b')
stem(hz, spectrum_Dshifted(1:length(hz)),'ro-','linew',2,'markersize',6,'markerfacecolor','r')
set(gca,'xlim', [0 Fs/2])
xlabel('Frequency (Hz)'), ylabel('Amplitude (a.u.)')
title(['Spectrum for Digit ', num2str(i),' up to nyquist Frequncy (Fs/2)']);
legend({'original (Same length)' 'Padded with zeros (Bigger length)' 'First 50 samples (Same length)'})
hold off
%% Comparing the estimated boundries vs. accurate boundries for two different signals.
clc
close all
UIN = 894; 
% Setting the parameters
unknown_signal = eval(['tpn', num2str(mod(UIN, 5))]);
unknown_signal = [zeros(20,1);unknown_signal;zeros(20,1)]; % Padding zeros at the first and the bottom of the signal to make sure that algorithm works fine!

std = 2e-3; %0.02;
mu = 1e-4;%1e-4;
% Calculate the accurate boundries before contamination using the
% "BND_Clean_Detection" function 
[end_indices,start_indices] = BND_Clean_Detection(unknown_signal);
% Calculate the estimated ones!
EST_BND_end = BND_Contaminated_Detection(unknown_signal, mu, std, 1);
BND_END_flip = BND_Contaminated_Detection(flip(unknown_signal,1), mu, std, 1);
EST_BND_start = length(unknown_signal) - flip(BND_END_flip,2) + 2; % + 2 for the flip effect
sprintf('The accurate pair of boundries (start, end) for the clean signal is: {(%d,%d),(%d,%d),(%d,%d),(%d,%d)}',start_indices(1), end_indices(1), start_indices(2),end_indices(2),...
        start_indices(3),end_indices(3), start_indices(4), end_indices(4))
sprintf('The estimated pair of boundries (start, end) for the contaminated signal is: {(%d,%d),(%d,%d),(%d,%d),(%d,%d)}',EST_BND_start(1), EST_BND_end(1), EST_BND_start(2),EST_BND_end(2),...
        EST_BND_start(3),end_indices(3), EST_BND_start(4), end_indices(4))
    
% Assess the algorithm for a totally different signal!   
UNKNOWN = [unknown_signal(start_indices(1):end_indices(1) - 100);zeros(300,1);unknown_signal(start_indices(2)+120:end_indices(2) - 50);...
           zeros(120,1);unknown_signal(start_indices(3)+100:end_indices(3) - 20);zeros(70,1);unknown_signal(start_indices(4)+90:end_indices(4) - 60); zeros(40,1)];
UNKNOWN = [zeros(20,1);UNKNOWN ;zeros(20,1)]; % Padding zeros at the first and the bottom of the signal to make sure that algorithm works fine!
% Calculate the accurate boundries before contamination using the
% "BND_Clean_Detection" function 
[end_indices,start_indices] = BND_Clean_Detection(UNKNOWN);
% Calculate the estimated ones!
EST_BND_end = BND_Contaminated_Detection(UNKNOWN, mu, std, 1);
BND_END_flip = BND_Contaminated_Detection(flip(UNKNOWN,1), mu, std, 1);
EST_BND_start = length(UNKNOWN) - flip(BND_END_flip,2) + 2;

sprintf('The accurate pair of boundries (start, end) for the clean signal is: {(%d,%d),(%d,%d),(%d,%d),(%d,%d)}',start_indices(1), end_indices(1), start_indices(2),end_indices(2),...
        start_indices(3),end_indices(3), start_indices(4), end_indices(4))
sprintf('The estimated pair of boundries (start, end) for the contaminated signal is: {(%d,%d),(%d,%d),(%d,%d),(%d,%d)}',EST_BND_start(1), EST_BND_end(1), EST_BND_start(2),EST_BND_end(2),...
        EST_BND_start(3),end_indices(3), EST_BND_start(4), end_indices(4))