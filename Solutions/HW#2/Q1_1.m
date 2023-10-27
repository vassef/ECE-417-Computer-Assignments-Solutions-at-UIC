%% Defining the funtion itself
n = 0:7;
x = (n+3) 
%% Start computing DFT
x8k = fft(x,8) % 8 point DFT
x16k = fft(x,16) % 16 poinr DFT
%% Showing that x8k[8-k] = x8k[k]*
for i = 2:length(x8k)
    S = x8k(length(x8k) + 2 - i) == conj(x8k(i));
    fprintf('x[%d] and x[10-%d] are %d\n', i, i, S);
end
    