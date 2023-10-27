% Define frequencies for the highpass filter
omega2 = 0.44 * pi + 0.2 * 894 * pi / 1000;
omega1 = pi - omega2;

% Design the highpass filter using firpm
filter_order_hp = 14;
filter_order_lp = filter_order_hp;
hHP = firpm(filter_order_hp, [0, omega1 / pi, omega2 / pi, 1], [0, 0, 1, 1]); % Notice the weights are swapped for the highpass filter
hLP = firpm(filter_order_lp, [0, omega1 / pi, omega2 / pi, 1], [1, 1, 0, 0]);
figure;
stem(0:length(hLP) - 1, hLP);
hold on
stem(0:length(hHP) - 1, hHP);
legend('low pass', 'high pass')
hold off
% Calculate the frequency response of the highpass filter
[HHP, ~] = freqz(hHP, 1, 1024);
[HLP, w] = freqz(hLP, 1, 1024);

% Q4.4: Calculate the stopband magnitude deviation
stopband_deviation_hp = max(abs(HHP(1:round(omega1 / (pi/1024) ) + 1)));
disp(['Q4.4: Stopband magnitude deviation for highpass filter: ', num2str(stopband_deviation_hp)]);

% Plot the absolute value of the sum of the frequency responses of the lowpass and highpass filters
combined_response = abs(HLP + HHP);
figure;
plot(w/pi, combined_response);
xlabel('Frequency (Normalized to Nyquist)');
ylabel('|HLP(ej?) + HHP(ej?)|');
title('Q4.5: Combined Frequency Response of Lowpass and Highpass Filters');

% Q4.6: Obtain the pole-zero plots for HLP(z) and HHP(z)
figure;
zplane(roots(hLP), [], 'Lowpass Filter');
title('pole-zero plots for HLP(z)')
figure;
zplane(roots(hHP), [], 'Highpass Filter');
title('pole-zero plots for HHP(z)')

% Q4.7: A signal 2 cos(?0n) is applied as input to the highpass filter with transfer function HHP(z).
% The output signal is y[n] = 0. Determine the possible values of ?0.

% We have HHP(z), and y[n] = 0. For y[n] = 0, the frequency response of HHP(z) must be zero at ?0.
% We can find the ?0 where HHP(ej?0) = 0.
figure;
plot(w/pi, abs(HHP))
title('Magnitude of frequency response of high pass filter')
zero_frequency_indices = find(abs(HHP) < 1e-4); % Find where HHP is close to zero

% Convert the indices to frequency values
possible_omega0 = zero_frequency_indices * (pi / 1024);
disp('Q4.7: Possible values of ?0 where HHP(z) = 0:');
disp(possible_omega0);
