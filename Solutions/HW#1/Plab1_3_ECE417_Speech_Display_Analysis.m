% Plab1_3_ECE417_Speech_Display_Analysis.m Updated 2020-09-06
% Display and examine a speech signal
[y,Fs] = audioread('ece417_audio.wav');
fprintf('Sampling frequency = %.1f Hz\nSampling Period = %.2f microsec\n', Fs,1000000/Fs)
clf

soundsc(y,Fs)
figure(1)
plot(y); 
title('Speech signal');
xlabel('Time sample index n')
ylabel('Amplitude y[n]')
pause(2)

figure(2)
plot(y(12501:19000)); %Plot of the second E sound in ECE
title('Sound "E"');
xlabel('Time sample index n')
ylabel('Amplitude y[n]')
soundsc(y(12501:19000),Fs); % "E"
pause(2)

figure(3)
plot(y(15210:15620)); %Plot of short segment the second E sound in ECE
title('A few pitch periods of Sound "E"');
xlabel('Time sample index n')
ylabel('Amplitude y[n]')
pause(2)

h=firpm(20,[0 0.01 0.15 1.0],[0 0 1 1],[1 1]); %highpass filter IR to remove DC
yf = conv(y,h); %highpass filter output y with DC content removed


figure(4)
plot(y(5601:7600))
title('Speech segment with sound "s" containing the DC content');
xlabel('Time sample index n')
ylabel('Amplitude y[n]')
soundsc(10 * y(5601:7600),Fs); % "s"
pause(2)

figure(5)
plot(yf(5601:7600))
title('Speech segment with sound "s" with DC content removed');
xlabel('Time sample index n')
ylabel('Amplitude y[n]')
soundsc(10 * yf(5601:7600), Fs) % "s"
pause(2)

figure(6)
subplot(2,1,1)
y1 = y(12501:19000); %voiced segment of y
[Y1,W]=freqz(y1); % Y1 is DTFT of y1
plot(W,abs(Y1));
xlabel('Frequency \omega')
ylabel('Magnitude of DTFT')
title('Voiced sound frequency content, letter E');
subplot(2,1,2)
y2 = yf(12501:19000); %yf(5601:7600); %unvoiced segment of y with DC removed
[Y2,W]=freqz(y2); % Y2 is DTFT of y2
plot(W,abs(Y2));
xlabel('Frequency \omega')
ylabel('Magnitude of DTFT')
title('Unvoiced sound frequency content, letter E');

figure(7)
subplot(2,1,1)
y1 = y(5601:7600); %voiced segment of y
[Y1,W]=freqz(y1); % Y1 is DTFT of y1
plot(W,abs(Y1));
xlabel('Frequency \omega')
ylabel('Magnitude of DTFT')
title('Voiced sound frequency content, letter S');
subplot(2,1,2)
y2 = yf(5601:7600); %yf(5601:7600); %unvoiced segment of y with DC removed
[Y2,W]=freqz(y2); % Y2 is DTFT of y2
plot(W,abs(Y2));
xlabel('Frequency \omega')
ylabel('Magnitude of DTFT')
title('Unvoiced sound frequency content, letter S');
