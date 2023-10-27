% Define the sequences x[n] and h[n]
n = 0:15;
x = (n + 3) .* (heaviside(n) - heaviside(n - 15));
h = heaviside(n) - heaviside(n - 5);

% Define the segment length and DFT length
M = 8; % Segment length
N = M + 5; % DFT length (M + L - 1, where L is the length of h[n])

% Zero-pad h[n] to match the DFT length
h_padded = [h, zeros(1, N - length(h))];

% Initialize the result y[n]
y = zeros(1, length(x) + length(h) - 1);

% Perform the convolution using overlap-save
for i = 1:M:length(x)
    % Extract a segment of x[n]
    x_segment = x(i:min(i + M - 1, length(x)));
    
    % Zero-pad the segment to match the DFT length
    x_segment_padded = [x_segment, zeros(1, N - length(x_segment))];
    
    % Compute the circular convolution of the segment with h[n]
    y_segment = ifft(fft(x_segment_padded, N) .* fft(h_padded, N));
    
    % Add the result to the appropriate location in y[n]
    start_index = i;
    end_index = min(i + N - 1, length(y));
    y(start_index:end_index) = y(start_index:end_index) + y_segment(1:(end_index - start_index + 1));
end

% Display the result y[n]
n_y = 0:(length(y) - 1);
stem(n_y, y);
title('Linear Convolution y[n]');
xlabel('n');
ylabel('Amplitude');
