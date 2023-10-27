clear
clc

% Define filter parameters
% stopbands = [0 0.25 0.75 1];  % Stopband edges
% passbands = [0.35 0.65];  % Passband edges
% desired_mags = [0 1 0];  % Desired magnitudes for each band
% deviations = [0.025 0.1 0.05];  % Peak magnitude deviations for each band

% Calculate filter order
n = firpmord([0.25 0.35 0.65 0.75], [0 1 0], [0.025 0.1 0.05], pi);
% n = 100;
% Design the filter
h = firpm(n, [0 0.25 0.35 0.65 0.75 1], [0 0 1 1 0 0], [0.025 0.1 0.05]);

[H, w] = freqz(h,1,100);
Hmax=max(abs(H));
figure()
plot(w, abs(H));%Plot the magnitude response of filter
xlabel('frequency');ylabel('DFT magnitude');
title('Magnitude of H versus frequency');




