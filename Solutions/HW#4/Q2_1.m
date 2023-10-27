% Define the frequencies and specifications
NID = 894; % You may use the specific NID value given in your problem
omega1 = 0.05 * pi + 0.2 * NID * pi / 1000;
desired_magnitudes = [2.0,2.0, 0.0,0.0, 1.0,1.0];
deviation_weights = [2, 1, 3]; % Twice, once, and three times the deviation for each band

% Design the 3-band filter using firpm
filter_order = 16; % Choose a sufficiently high filter order (you may adjust this)
band_edges = [0, omega1 + 0.1 * pi, omega1 + 0.25 * pi, omega1 + 0.45 * pi, omega1 + 0.6 * pi, pi];
h3B = firpm(filter_order, band_edges / pi, desired_magnitudes, deviation_weights);
% Calculate the frequency response of the filter
[H3B, w] = freqz(h3B, 1, 1024);

% Q4.8: Show the specifications used in the command "firpm" to obtain h3B
disp('Q4.8: Filter Specifications for h3B');
disp('Band Edges (Normalized to Nyquist):');
disp(band_edges / pi);
disp('Desired Magnitudes:');
disp(desired_magnitudes);
disp('Deviation Weights:');
disp(deviation_weights);

% Q4.9: Find the peak absolute magnitude deviation from the desired value in each of the three bands
peak_deviations = zeros(3, 1);
for i = 1:3
    band_start = round(band_edges(2*i - 1) * 1024 / pi) + 1;
    band_end = round(band_edges(2*i) * 1024 / pi);
    peak_deviations(i) = max(abs(H3B(band_start:band_end)) - desired_magnitudes(2*i-1));
end

disp('Q4.9: Peak Absolute Magnitude Deviations:');
disp(peak_deviations);

% Plot the magnitude response of the filter
figure;
plot(w/pi, abs(H3B));
xlabel('Frequency (Normalized to Nyquist)');
ylabel('|H3B(ej?)|');
title('Filter Magnitude Response');

% Q4.10: Modify the filter for different specifications
% To achieve desired magnitudes [3.0, 1.0, 2.0] with the same deviation requirements
desired_magnitudes_modified = [3.0, 3.0, 1.0, 1.0, 2.0, 2.0];
h3B_modified = firpm(filter_order, band_edges / pi, desired_magnitudes_modified, deviation_weights);
% 
% Calculate the frequency response of the modified filter
[H3B_modified, w] = freqz(h3B_modified, 1, 1024);

% Plot the magnitude response of the modified filter
figure;
plot(w/pi, abs(H3B_modified));
xlabel('Frequency (Normalized to Nyquist)');
ylabel('|H3B_modified(ej?)|');
title('Modified Filter Magnitude Response for [3.0, 1.0, 2.0] Magnitudes');
