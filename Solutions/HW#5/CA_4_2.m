clc
close all
dp=0.01;
ds=0.01;
NID = 894;
fp=0.375 - NID * 1e-4;
fs=0.475 + NID * 1e-4;
Fsampl=2;
fr_edge = [0 2*fp/Fsampl, 2*fs/Fsampl 1];
des_mag = [1, 0];
[nell_ord, wn] = ellipord(2*fp/Fsampl, 2*fs/Fsampl, -20*log10(1-dp), -20*log10(ds));% Filter order & parameter wn are computed.
[b_ell,a_ell] = ellip(nell_ord, -20*log10(1-dp), -20*log10(ds), wn);% Filter
[Hell,w]=freqz(b_ell,a_ell,501);% Frequency response is computed.
figure;
plot(w/pi,abs(Hell));
xlabel('w/pi')
ylabel('Magnitude H(e^jw)')
title('Magnitude response of the Elliptic lowpass filter (Before quantization)')
disp('Estimated filter order:')
disp(nell_ord)
figure;
plot(w(1:201)/pi,abs(Hell(1:201)))
xlabel('w/pi')
ylabel('Magnitude H(e^jw)')
title('Zoomed Magnitude response of the Elliptic lowpass filter (Before quantization)')
% new
disp('r_max before quantization is:')
disp(max(abs(roots(a_ell))))
disp('peak contribution before quantization')
disp(1/(1-max(abs(roots(a_ell)))))
contribution = zeros(1,6);
contribution(1) = 1/(1-max(abs(roots(a_ell))));
c = 0;
legends = cell(size(6));
figure;
plot(w(1:201)/pi,abs(Hell(1:201)))
legends{1} = sprintf('Before quantization');
hold on
for i = [2,4,6,8,10]
    c = c + 1;
    bq_ell=quant(b_ell, 1/(2^i));
    aq_ell=quant(a_ell, 1/(2^i));
    [Hqell,~]=freqz(bq_ell,aq_ell,501);
    plot(w(1:201)/pi,abs(Hqell(1:201)))
    xlabel('w/pi')
    ylabel('Magnitude H(e^jw)')
    title('Zoomed Magnitude response comparison)')
    legends{c+1} = sprintf('%d bits', i);
    %label axes in plot, put title, etc.
    sprintf('rq_max after quantization by %d bits is %d:', i, max(abs(roots(aq_ell))))
    %disp(max(abs(roots(aq_ell))))
    sprintf('peak contribution after quantization by %d bits is %d:', i, 1/(1-max(abs(roots(aq_ell)))))
    contribution(c+1) = 1/(1-max(abs(roots(aq_ell))));
%     disp('peak contribution after quantization')
%     disp(1/(1-max(abs(roots(aq_ell)))))
end
legend(legends)
hold off
figure;
stem([0,2,4,6,8,10],contribution)
xlabel('Bits using for quantization')
ylabel('peak contribution')
title('Sensitivity of the closest pole to unit circle to quantization effect')