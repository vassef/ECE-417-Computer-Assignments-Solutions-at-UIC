% Define frequencies and band edges
omega1 = 0.05 * pi + 0.2 * NID * pi / 1000;
band_edges = [0, omega1 + 0.1 * pi, omega1 + 0.25 * pi, omega1 + 0.4 * pi, omega1 + 0.6 * pi, pi];

% Specify the piecewise linear desired magnitudes
desired_magnitudes = [3.0,1.0, 0.0,0.0, 1.0,3.0];
peak_deviation = [1.0, 2.0, 1.0]; % Equal weights for pass-bands, double weight for stop-band

% Design the filter using firpm
N = 20; % Filter order
hPL = firpm(N, band_edges/ pi, desired_magnitudes, peak_deviation);
disp('Filter Specifications for hPL');
disp('Band Edges (Normalized to Nyquist):');
disp(band_edges / pi);
disp('Desired Magnitudes:');
disp(desired_magnitudes);
disp('Deviation Weights:');
disp(peak_deviation);

% Calculate the frequency response of the filter
[HPL, w] = freqz(hPL, 1, 1024);

% Plot the magnitude response
figure;
plot(w/pi, abs(HPL));
title('Magnitude Response of hPL(z)');
xlabel('Normalized Frequency (\omega/\pi)');
ylabel('Magnitude');
grid on;
