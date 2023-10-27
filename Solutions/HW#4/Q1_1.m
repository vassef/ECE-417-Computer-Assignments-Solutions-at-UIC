% Define frequencies (As we want to implement a low pass filter, omega 2
% should be greater than omega1. 
omega2 = 0.44 * pi + 0.2 * 894 * pi / 1000;
omega1 = pi - omega2;

% Specify filter order values
filter_orders = [6, 14, 22, 30, 38];

% Initialize arrays to store results
stopband_deviation = zeros(size(filter_orders));
filter_order_vs_deviation = zeros(size(filter_orders));
% Initialize a cell array to store legends
legends = cell(size(filter_orders));

% Loop over different filter orders
for i = 1:length(filter_orders)
    % Design the filter using firpm
    N = filter_orders(i);
    hLP = firpm(N, [0, omega1 / pi, omega2 / pi, 1], [1, 1, 0, 0]);
    
    % Calculate the frequency response of the filter
    [HLP, w] = freqz(hLP, 1, 1024);
    plot(w/pi, abs(HLP))
    hold on
    legends{i} = sprintf('Filter Order %d', N);
    % Calculate the stopband peak absolute deviation
    stopband_deviation(i) = max(abs(HLP(round(omega2 / (pi/1024) )+1 :end)));
    
    % Store filter order vs. deviation for plotting
    filter_order_vs_deviation(i) = - 20 * log10(stopband_deviation(i));
end

legend(legends)
title('Magnitude of frequncy response for different filter orders')
hold off

% Plot the deviation vs. filter order
figure;
plot(filter_orders, filter_order_vs_deviation, 'bo-');
xlabel('Filter Order');
ylabel('-20*log10(?s)');
title('Stopband Deviation vs. Filter Order');

% Estimate filter order for -20*log10(?s) = 50
desired_deviation = 10^(-50/20); % Desired -20*log10(?s) value
estimated_order = firpmord([omega1/pi, omega2/pi], [1, 0], [desired_deviation, desired_deviation])

% Verify the estimated filter order using firpm
hLP_verified = firpm(estimated_order, [0, omega1 / pi, omega2 / pi, 1], [1, 1, 0, 0]);
[HLP_verified, w] = freqz(hLP_verified, 1, 1024);
estimated_deviation = - 20 * log10(max(abs(HLP_verified(round(omega2 / (pi/1024) )+1 :end))))
% Show the impulse response for filter order 14
filter_order_to_check = 14;
hLP_order14 = firpm(filter_order_to_check, [0, omega1 / pi, omega2 / pi, 1], [1, 1, 0, 0]);

% Plot the impulse response
figure;
stem(0:length(hLP_order14) - 1, hLP_order14);
xlabel('n');
ylabel('hLP[n]');
title('Impulse Response for Filter Order 14');

% Check for zero values in the impulse response
zeros_indices = find(abs(hLP_order14) < 1e-4);
if isempty(zeros_indices)
    disp('No zero values in the impulse response.');
else
    disp('Zero values found in the impulse response.');
end

% Check for symmetry around the middle non-zero sample
middle_index = ceil(length(hLP_order14) / 2);
if all((zeros_indices(1:length(zeros_indices)/2)+ 8) == zeros_indices(length(zeros_indices)/2 + 1:end))
    disp('zero indexes are symmetric around the middle non-zero sample.');
else
    disp('zero indexes are symmetric around the middle non-zero sample.');
end
