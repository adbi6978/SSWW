function [refimOut,dataimOut] = filterIMG(refim,dataim)
N = size(refim,1);
f_0 = 2.8;

domain_length = N/f_0;
dx = domain_length/N;
dk = 2*pi/domain_length;
kx= fftshift(dk*[-N/2:N/2-1]);

i = round(N/2);
[pks,freq] = findpeaks(abs(fft(refim(i,:))));
[~,centralFrequencyInd] = max(pks(1:round(end/2)));
centralFrequency = kx(freq(centralFrequencyInd));
scaledFrequency = kx(freq(centralFrequencyInd))/max(kx);
    
d = designfilt('bandpassiir','FilterOrder',10,...
    'HalfPowerFrequency1',.8*scaledFrequency,'HalfPowerFrequency2',1.2*scaledFrequency);
refimOut= filter(d,refim')';
dataimOut= filter(d,dataim')';

disp('Bandpass filtering is done...')
end