load('irviolin.mat'); % loads the vector impresp_violin
a = 1; % denominator for FIR filter
b = impresp_violin;
%d = b.impresp_violin;
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
yA3 = filter(b,a,pt);% generates signal y_{A_3} for note A3 of duration Ndur s
vA3 = yA3.*scalefn; % generates shaped signal v_{A_3}

soundsc(vA3,Fs);
audiowrite('vA3_FIR.wav',vA3,Fs)
pause(4)
soundsc(yA3,Fs);
audiowrite('yA3_FIR.wav',yA3,Fs)


