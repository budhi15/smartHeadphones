%using istft package
%http://www.mathworks.com/matlabcentral/fileexchange/45577-inverse-short-time-fourier-transformation--istft--with-matlab-implementation
addpath('../../istft');
%{
features = 0;
wlen = 25;
h = 10;
nfft = wlen;
fs = 44100;

%build array of sounds
files = dir('../Sound Samples/Cleaned Data/Phone Rings/R*.wav');
for file=files'
    sound = audioread(strcat('../Sound Samples/Cleaned Data/Phone Rings/',file.name));
    sound = sound(:,1);
    % Feature extraction (feature vectors as columns)
    %[ MFCCs, FBEs, frames ] = ...
     %               mfcc( sound, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C, L );
    [ostft, f, t_stft] = stft(sound, wlen, h, nfft, fs);
     if features == 0
        features = ostft;
    else
        features = [features, ostft];
    end
end
features = abs(features);
%features = features(2:end,:);
%extract nmf features from sounds
num_features = 12;
nmffeatures = nnmf(features,num_features);
nmfweights = transpose(nmffeatures)*features;
for i=1:num_features
    subplot(num_features/3,3,i);
    plot(nmffeatures(:,i));
end
figure;

for i=1:num_features
    subplot(num_features/3+1,3,i);
    plot(nmfweights(i,:));
end
subplot(num_features/3+1,1,num_features/3+1);
imagesc(features);
%}
sound = audioread('../Sound Samples/Cleaned Data/Background/B01.wav');
sound = sound(:,1).';                       
xmax = max(abs(sound));                 
sound = sound/xmax; 
[extracted, f, t_stft] = stft(sound, wlen, h, nfft, fs);
extracted = abs(extracted);
exweights = transpose(nmffeatures)*extracted;
phonefeatures = nmffeatures*exweights;

[root_istft, t_istft] = istft(phonefeatures, h, nfft, fs);                       
rmax = max(abs(root_istft));
root_istft = root_istft/rmax; 
hold on
subplot(3,1,1);
plot(sound(1,1:size(root_istft,2)));
subplot(3,1,2);
plot(root_istft);
subplot(3,1,3);
plot(sound(1,1:size(root_istft,2))-root_istft);
hold off

wavwrite(root_istft,fs,'extracted_phone.wav');
wavwrite(sound(1,1:size(root_istft))-root_istft,fs,'extracted_sound.wav');