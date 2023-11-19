
%% Loading
clc
close all
load('tones.mat')
load('telephone_numbers.mat')
%% Q6.1
clc
close all
%digits = cell(1, 10);  % Create an array to store digit signals
digits = cell(11,4);
digits(1,:) = {'digit','freq1','freq2','Energy'};
% Loop through each digit (0 to 9)
for i = 0:9
    % Compute the magnitude spectrum using FFT
    digit_signal = eval(['u', num2str(i)]);
    pnts = length(digit_signal);
    spectrum = abs(fft(digit_signal)/pnts);
    hz = linspace(0,Fs/2,floor(pnts/2)+1);
    
    % Detect the frequencies of the two dominant peaks
    [sorted_spectrum, sorted_indices] = sort(spectrum(1:length(hz)), 'descend');
    first_peak = sorted_indices(1);
    second_peak = sorted_indices(2);
    
    % Convert peak indices to frequencies
    freq1 = hz(first_peak);
    freq2 = hz(second_peak);
    
    %digits{i + 1} = struct('digit', i, 'freq1', freq1, 'freq2', freq2, 'Energy', sum(digit_signal.^2));
    digits(i+2,:) = {i, freq1, freq2, sum(digit_signal.^2)};
    % Plot the spectrum
    figure;
    stem(hz, spectrum(1:length(hz)),'ko-','linew',2,'markersize',6,'markerfacecolor','r')
    set(gca,'xlim', [0 Fs/2])
    xlabel('Frequency (Hz)'), ylabel('Amplitude (a.u.)')
    title(['Spectrum for Digit ', num2str(i),' up to nyquist Frequncy (Fs/2)']);
end

C = digits(2:end,:);
ref = cell2table(C);
Col = digits(1,:);
ref.Properties.VariableNames = Col;
%% Q6.3 & Q6.4
clc
close all
UIN = 894;
unknown_signal = eval(['tpn', num2str(mod(UIN, 5))]);
unknown_signal = [zeros(20,1);unknown_signal;zeros(20,1)]; % Padding zeros at the first and the bottom of the signal to make sure that algorithm works fine!
fs = Fs;
mu = 1e-8;
std = 0.002; % Setting std to minimum to have the correct boundries!
[digits, SNR] = Decode_hidden_digits(unknown_signal, fs, mu, std, ref);
sprintf('Hidden digits in order are: (%d,%d,%d,%d)',digits(1), digits(2), digits(3), digits(4))
%% Q6.5
STD = linspace(0.0,0.25,25);
mu = 1e-4;
Summary = zeros(25,8); % 8 columns, including {std, mu, digit1_encoded, digit1_encoded, digit2_encoded, digit3_encoded, digit4_encoded, SNR, Mistmatch(per_bits)}
for i = 1:25
    [digits, SNR] = Decode_hidden_digits(unknown_signal, fs, mu, STD(i), ref);
    Summary(i,1) = STD(i);
    Summary(i,2) = mu;
    Summary(i,3:6) = digits;
    Summary(i,7) = SNR;
    diff = digits - [6 5 0 7];
    Summary(i,8) = 4 - length(diff(diff == 0));
end

Table_summary = array2table(Summary, 'VariableNames', ...
{'std', 'mu', 'digit1_encoded', 'digit2_encoded', 'digit3_encoded', 'digit4_encoded', 'SNR', 'Mistmatch_per_bits'});
display(Table_summary)
writetable(Table_summary,'Tone_detection.xlsx','Sheet','Summary')

            
