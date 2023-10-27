
% Read the noisy speech signal
[noisy_speech, fs] = audioread('noisy_speech.wav'); % Replace with your file path
soundsc(noisy_speech, fs)
pause(4)
% Design the FIR denoising filter using firpm
order = 30; % Filter order

% Design the filter
denoising_filter = firpm(order, [0 , 0.1, 0.25, 1], [1, 1 , 0, 0], [0.05, 0.05]);
freqz(denoising_filter)
% Apply the FIR filter to denoise the speech
denoised_speech = conv(noisy_speech,denoising_filter);

% Listen to the denoised speech
soundsc(10 * denoised_speech, fs);
pause(4)
% Listen to the noisy speech (optional for comparison)
% sound(noisy_speech, fs);

% Read the clean original speech for comparison
[clean_speech, fs] = audioread('ece417_audio.wav'); % Replace with your file path
soundsc(clean_speech, fs);


% Specify the output file name and path
output_filename = 'denoised_speech.wav'; % Replace with your desired file name
output_path = ''; % Specify the path if needed

% Create the full output file path
output_filepath = fullfile(output_path, output_filename);

% Save the denoised speech as a .wav file
audiowrite(output_filepath, denoised_speech, fs);

% Display a message indicating the file has been saved
fprintf('Denoised speech saved as %s\n', output_filepath);

