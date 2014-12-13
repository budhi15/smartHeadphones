%phonerings = getfeatures('../Sound Samples/Cleaned Data/Phone Rings/R*.wav');
%background = getfeatures('../Sound Samples/Cleaned Data/Background/B*.wav');
%sound = audioread('../Sound Samples/Cleaned Data/Background/B01.wav');

wlen = 25;
h = 10;
nfft = wlen;
fs = 44100;
features = [phonerings,background];

%[extracted, f, t_stft] = stft(sound, wlen, h, nfft, fs);

%extracted = real(extracted);

weights = features\extracted;

phonecomponent = phonerings.'*weights(1:13,:);
backcomponent = background.'*weights(14:end,:);
[phonesound, t_stft] = istft(phonecomponent, h, nfft, fs);
wavwrite(phonesound,fs,'phonefeatures.wav');
[backsound, t_stft] = istft(backcomponent, h, nfft, fs);
wavwrite(backsound,fs,'backfeatures.wav');
