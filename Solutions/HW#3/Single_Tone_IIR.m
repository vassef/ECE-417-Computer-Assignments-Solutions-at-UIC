
Fs = 44100; % Sampling frequency, # of samples in 1 sec, integer
Tdur = 1; % The note should be played for 2 seconds
Ndur = round(Tdur*Fs); % # of samples in Tdur seconds
n=[0:Ndur-1]; % index set [0 1 2 3 ... Ndur-1]
scalefn = sin(pi*n/(Ndur));
scalefn = scalefn.*scalefn; % modulating function for the note
Fpd = 220; % pitch frequency desired
Np = round(Fs/Fpd); % # samples in pitch period, rounded.
% Np is used in pulse train generation
tem = n/Np - round(n/Np);
% entry in tem is zero when corresponding entry in n is a multiple of Np
pt = (tem == 0); % creates pulse train
% Plot and compare waveforms for 3 pitch periods

NumPeriods = 3;
samples_per_period = Np;
samples_to_extract = samples_per_period * NumPeriods;

% FIR filter

load('irviolin.mat'); % loads the vector impresp_violin
a = 1; % denominator for FIR filter
b = impresp_violin;
figure(1)
freqz(b,a,1024)
title('Frequency response - FIR Filter');
x_fir = filter(b,a,pt);% generates signal y_{A_3} for note A3 of duration Ndur s
figure(2)
% FIR Filter Plot
subplot(2, 1, 1);
plot(0:(samples_to_extract - 1), x_fir(1:samples_to_extract), 'b'); % Extract 3 pitch periods (adjust as needed)
title('Waveform - FIR Filter');
xlabel('Sample');
ylabel('Amplitude');
x_fir = x_fir.*scalefn; % generates shaped signal v_{A_3}

% IIR filter

a = 0.1; % denominator for FIR filter
b = [1.0000 -2.4584 1.8539 -0.2387 -0.0466 -0.1614 -0.1004 0.1980 -0.0420];
x_iir = filter(a,b,pt);% generates signal y_{A_3} for note A3 of duration Ndur s
audiowrite('yA3_IIR.wav',x_iir,Fs)
% IIR Filter Plot
subplot(2, 1, 2);
plot(0:(samples_to_extract - 1), x_iir(1:samples_to_extract), 'r'); % Extract 3 pitch periods (adjust as needed)
title('Waveform - IIR Filter');
xlabel('Sample');
ylabel('Amplitude');

x_iir = x_iir.*scalefn; % generates shaped signal v_{A_3}
audiowrite('vA3_IIR.wav',x_iir,Fs)

soundsc(x_fir,Fs);
pause(4)
soundsc(x_iir,Fs);

figure(3)
freqz(a,b,1024)
title('Frequency response - IIR Filter');

figure(4)
plot(0:1000, pt(1:1001))
title("impulse train (Pt)")
ylim([0,1.5])










