function [digits, SNR] = Decode_hidden_digits(unknown_signal, Fs, mu, std, reference_table)


if std == 0
    [EST_BND_end,EST_BND_start] = BND_Clean_Detection(unknown_signal);
else
    EST_BND_end = BND_Contaminated_Detection(unknown_signal, mu, std, 1);
    BND_END_flip = BND_Contaminated_Detection(flip(unknown_signal,1), mu, std, 1);
    EST_BND_start = length(unknown_signal) - flip(BND_END_flip,2) + 2; %  + 2 for the flip effect
end


Hidden_signal_end = zeros(4,256);
Hidden_digits_end = zeros(1,4);
% one time -> loop over the end indices
idx_end = 1:4;
if EST_BND_end(1) < 256
    Hidden_signal_end(1,:) = [unknown_signal(1:EST_BND_end(1));zeros(256 - EST_BND_end(1),1)]';
    idx_end = 2:4;
end

for i = idx_end
    Hidden_signal_end(i,:) = unknown_signal(EST_BND_end(i) - 256: EST_BND_end(i) - 1)';
end

for i = 1:4 % find Hidden digits using the estimated end indices
    digit_signal = Hidden_signal_end(i,:);
    pnts = length(digit_signal);
    spectrum = abs(fft(digit_signal)/pnts);
    hz = linspace(0,Fs/2,floor(pnts/2)+1);
    
    % Detect the frequencies of the two dominant peaks
    [~, sorted_indices] = sort(spectrum(1:length(hz)), 'descend');
    first_peak = sorted_indices(1);
    second_peak = sorted_indices(2);
    
    % Convert peak indices to frequencies
    freq1_end = hz(first_peak);
    freq2_end = hz(second_peak);
    
    Filtered_table = reference_table((reference_table.freq1 == freq1_end & reference_table.freq2 == freq2_end) | ...
                                     (reference_table.freq1 == freq2_end & reference_table.freq2 == freq1_end),:);
    if size(Filtered_table,1) ~= 0
        Hidden_digits_end(i) = Filtered_table.digit;
    else
        
        Hidden_digits_end(i) = -1; % -1 is a symbol of unkown digit that was not found during the decoding procedure!

    end
end
    
Hidden_signal_start = zeros(4,256);
Hidden_digits_start = zeros(1,4);
idx_start = 1:4;
% one time -> loop over the end indices
if length(unknown_signal) - EST_BND_start(4) + 1 < 256
    Hidden_signal_start(4,:) = [zeros(255 + EST_BND_start(4) - length(unknown_signal),1);unknown_signal(EST_BND_start(4):end)]';
    idx_start = 1:3;
end

for j = idx_start
    Hidden_signal_start(j,:) = unknown_signal(EST_BND_start(j):EST_BND_start(j) + 255)';
end

for j = 1:4 % find Hidden digits using the estimated end indices
    digit_signal = Hidden_signal_start(j,:);
    pnts = length(digit_signal);
    spectrum = abs(fft(digit_signal)/pnts);
    hz = linspace(0,Fs/2,floor(pnts/2)+1);
    
    % Detect the frequencies of the two dominant peaks
    [~, sorted_indices] = sort(spectrum(1:length(hz)), 'descend');
    first_peak = sorted_indices(1);
    second_peak = sorted_indices(2);
    
    % Convert peak indices to frequencies
    freq1_start = hz(first_peak);
    freq2_start = hz(second_peak);
    
    Filtered_table = reference_table((reference_table.freq1 == freq1_start & reference_table.freq2 == freq2_start)|...
                                     (reference_table.freq1 == freq2_start & reference_table.freq2 == freq1_start),:);
    if size(Filtered_table,1) ~= 0
        Hidden_digits_start(j) = Filtered_table.digit;
    else
        Hidden_digits_start(j) = -1; % -1 is a symbol of unkown digit that was not found during the decoding procedure!
    end
      
end 

if length(Hidden_digits_start(Hidden_digits_start == -1)) < length(Hidden_digits_end(Hidden_digits_end == -1))
    digits = Hidden_digits_start;
else
    digits = Hidden_digits_end;
end
        
SNR = snr(unknown_signal, mu + std * randn(length(unknown_signal),1));

end

