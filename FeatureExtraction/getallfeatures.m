%phonerings = getfeatures('../Sound Samples/Cleaned Data/Phone Rings/R*.wav');
%background = getfeatures('../Sound Samples/Cleaned Data/Background/B*.wav');
%sound = audioread('../Sound Samples/Cleaned Data/Background/B01.wav');

wlen = 25;
h = 10;
nfft = wlen;
fs = 44100;
%features = [phonerings,background];
%features = phonerings;
%[extracted, f, t_stft] = stft(sound, wlen, h, nfft, fs);
%extracted = real(extracted);
%[xsound, t_stft] = istft(extracted, h, nfft, fs);

%weights = features\extracted;

%phonecomponent = phonerings*weights(1:size(features,2)/2,:);
%backcomponent = background*weights(size(features,2)/2+1:end,:);
%phonecomponent = features*weights;

phoneweights = phonerings(:,1:6)\extracted;
backweights = background(:,1:6)\extracted;

phonecomponent = phonerings(:,1:6)*phoneweights(1:6,:);
backcomponent = background(:,1:6)*backweights(1:6,:);
filter = abs(phonecomponent)>abs(backcomponent);
phonex = extracted.*(abs(phonecomponent)>abs(backcomponent));
backx = extracted.*(abs(backcomponent)>abs(phonecomponent));

[phonesound, t_stft] = istft(phonex, h, nfft, fs);
[backsound, t_stft] = istft(backx, h, nfft, fs);
hold on
subplot(4,2,1);
imagesc(log(abs(extracted)));
subplot(4,2,2);
plot(sound);
subplot(4,2,3);
imagesc(log(abs(phonecomponent)));
subplot(4,2,4);
plot(phonesound);
subplot(4,2,5);
imagesc(log(abs(backcomponent)));
subplot(4,2,6);
plot(backsound);
subplot(4,2,7);
imagesc(filter);
subplot(4,2,8);
plot(xsound-phonesound-backsound);
colormap(gray);
hold off

wavwrite(phonesound,fs,'phonefeatures.wav');
wavwrite(backsound,fs,'backfeatures.wav');
