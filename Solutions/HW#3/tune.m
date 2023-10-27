% Load the FIR filter impulse response
load('irviolin.mat');
a = 1; % denominator for FIR filter
b = impresp_violin;
% Sampling frequency
Fs = 44100;

% Define note frequencies and durations (in seconds)
note_freqs = [261.61, 293.66, 329.63, 261.61, 329.63, 261.61, 329.63]; % C4, D4, E4
note_durations = [0.5, 0.5, 1.0, 0.5, 1, 0.5, 1]; % durations of each note
note_durations = [0.5, 0.5, 0.75, 0.5, 1, 0.5, 0.5]; % durations of each note
% Initialize the tune as an empty array
tune = [];

% Create each note and concatenate to form the tune
for i = 1:length(note_freqs)
    Fpd = note_freqs(i); % Frequency of the current note
    Tdur = note_durations(i); % Duration of the current note in seconds
    
    % Rest (silence) between notes
    if i > 1
        if i == 5
        rest_duration = 0; % Adjust as needed
        else
            rest_duration = 0.05;
        end
        tune = [tune, zeros(1, round(rest_duration * Fs))];
    end
    
    % Generate the note using the previous code
    Ndur = round(Tdur*Fs); % # of samples in Tdur seconds
    n=[0:Ndur-1]; % index set [0 1 2 3 ... Ndur-1]
    scalefn = sin(pi*n/(Ndur));
    scalefn = scalefn.*scalefn; % modulating function for the note
    Np = round(Fs/Fpd); % # samples in pitch period, rounded.
    % Np is used in pulse train generation
    tem = n/Np - round(n/Np);
    % entry in tem is zero when corresponding entry in n is a multiple of Np
    pt = (tem == 0); % creates pulse train
    yA3 = filter(b,a,pt);% generates signal y_{A_3} for note A3 of duration Ndur s
    vA3 = yA3.*scalefn; % generates shaped signal v_{A_3}
    % ... (similar to the previous code)
    
    % Concatenate the note to the tune
    tune = [tune, vA3]; % Replace vA3 with the current note
    
end

% Play the tune
soundsc(tune, Fs);

% Save the tune as an audio file
audiowrite('tune.wav', tune, Fs);
