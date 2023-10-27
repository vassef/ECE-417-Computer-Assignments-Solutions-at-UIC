
clf;
NID = input('Type in N_ID = ');
fp=0.31+0.14*NID/1000;
fs=1-fp;
% Define the sampling frequency and Nyquist frequency
%fs = 1; % Sampling frequency
nyquist_freq = fs / 2; % Nyquist frequency

% Corrected passband and stopband frequencies
fpass = [0.35, 0.65] * nyquist_freq;
fstop1 = [0, 0.25] * nyquist_freq; % Adjusted first stopband
fstop2 = [0.75, 1] * nyquist_freq; % Adjusted second stopband

delta_stop1 = 0.025;
delta_pass = 0.1;
delta_stop2 = 0.05;

% Calculate the minimum filter order using the firpmord function
forder = firpmord([fstop1(2), fpass(1), fpass(2), fstop2(1)],[0, 1, 0], [delta_stop1, delta_pass, delta_stop2], fs);

% Design the filter using firpm with the calculated order
b = firpm(forder, [fstop1(1), fstop1(2), fpass(1), fpass(2), fstop2(1), fstop2(2)], [0, 0, 1, 1, 0, 0], [delta_stop1, delta_pass, delta_stop2]);

% Plot the frequency response
freqz(b, 1, 1024, fs);

% Display the minimum filter order
fprintf('Minimum filter order needed: %d\n', forder);
