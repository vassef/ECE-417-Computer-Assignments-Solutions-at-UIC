% Load and listen to the clean signal
[clean_signal, fs] = audioread('clean_signal.wav');
sound(clean_signal, fs); % fs is the sampling frequency of the signal

pause(4)
% Load and listen to the contaminated signal
[contaminated_signal, fs] = audioread('signal_plus_noise.wav');
sound(contaminated_signal, fs);
pause(4)
% Compute and plot the DFT of the clean signal
clean_signal_dft = fft(clean_signal);
contaminated_signal_dft = fft(contaminated_signal);

figure(1)
subplot(2, 1, 1);
plot(abs(clean_signal_dft));
title('DFT of Clean Signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

subplot(2, 1, 2);
plot(abs(contaminated_signal_dft));
title('DFT of Contaminated Signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% Design the FIR filter using firpm
order = 32;
passband_second_freq = 2500;
passband = [0, passband_second_freq]/fs; % Passband frequency range (normalized)
stopband = [6156, fs]/fs;
desired_mag = [1, 1, 0, 0]; % Desired magnitude response in passband and stopband

% Design the filter
denoising_filter = firpm(order, [passband(1),passband(2),stopband(1), stopband(2)], desired_mag, [1,1]);
% Plot the magnitude response of the FIR filter
figure(2)
freqz(denoising_filter, 1, 1024, fs);
title('Filter Magnitude Response');

% Apply the FIR filter to remove contamination
filtered_signal = conv(contaminated_signal, denoising_filter); % filter(denoising_filter, 1, contaminated_signal);
% ... (previous code to design and denoise the speech)

% Specify the output file name and path
output_filename = 'De_Contaminated_Voice.wav'; % Replace with your desired file name
output_path = ''; % Specify the path if needed

% Create the full output file path
output_filepath = fullfile(output_path, output_filename);

% Save the denoised speech as a .wav file
audiowrite(output_filepath, filtered_signal, fs);

% Display a message indicating the file has been saved
fprintf('De-contaminated voice saved as %s\n', output_filepath);

% Listen to the de-contaminated signal
sound(filtered_signal, fs);
% Comparing the DFT of the Original and the de-contaminated signal
filtered_signal_dft = fft(filtered_signal);

figure(3)
subplot(2, 1, 1);
plot(abs(clean_signal_dft));
title('DFT of Clean Signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

subplot(2, 1, 2);
plot(abs(filtered_signal_dft));
title('DFT of De-Contaminated Signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

figure(4)
subplot(3, 1, 1);
plot(clean_signal);
title('Clean Signal');
xlabel('Time');
ylabel('Amplitude');

subplot(3, 1, 2);
plot(contaminated_signal);
title('Contaminated Signal');
xlabel('Time');
ylabel('Amplitude');

subplot(3, 1, 3);
plot(filtered_signal);
title('De-Contaminated Signal');
xlabel('Time');
ylabel('Amplitude');
%
% Compute the mean squared error (MSE) between the clean and filtered signals
clean_signal_length = length(clean_signal);
for i = 0:1:order
    filtered_signal_new = filtered_signal(1 + i:clean_signal_length + i);
    mse2 = mean((clean_signal - filtered_signal_new).^2);
    fprintf('MSE between clean and filtered signals for i = %d\n: %f\n', i, mse2);
end
% Compute the mean squared error (MSE) between the clean and contaminated signals
mse1 = mean((clean_signal - contaminated_signal).^2);
fprintf('MSE between clean and contaminated signals: %f\n', mse1);

filtered_signal_new = filtered_signal(1 + order / 2 :clean_signal_length + order/2); % N/2 shift will give the minimum MSE
mse2 = mean((clean_signal - filtered_signal_new).^2);
fprintf('Correct MSE (Minimum one) between clean and filtered signals for passband second frequency = %d: %f\n', passband_second_freq, mse2);
% Compare MSE1 and MSE2





