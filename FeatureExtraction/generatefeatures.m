%requires mfcc package
%http://www.mathworks.com/matlabcentral/fileexchange/32849-htk-mfcc-matlab
addpath('../../mfcc/mfcc');

features = 0;
Tw = 25;                % analysis frame duration (ms)
Ts = 10;                % analysis frame shift (ms)
alpha = 0.97;           % preemphasis coefficient
M = 20;                 % number of filterbank channels 
C = 14;                 % number of cepstral coefficients
L = 22;                 % cepstral sine lifter parameter
LF = 20;               % lower frequency limit (Hz)
HF = 8000;              % upper frequency limit (Hz)
fs = 44100;

%build array of sounds
files = dir('../Sound Samples/Cleaned Data/Phone Rings/*.wav');
for file=files'
    sound = audioread(strcat('../Sound Samples/Cleaned Data/Phone Rings/',file.name));
    sound = sound(:,1);
    % Feature extraction (feature vectors as columns)
    [ MFCCs, FBEs, frames ] = ...
                    mfcc( sound, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C, L );
    if features == 0
        features = MFCCs;
    else
        features = [features, MFCCs];
    end
end

files = dir('../Sound Samples/Cleaned Data/Background/*.wav');
for file=files'
    sound = audioread(strcat('../Sound Samples/Cleaned Data/Background/',file.name));
    % Feature extraction (feature vectors as columns)
    [ MFCCs, FBEs, frames ] = ...
                    mfcc( sound, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C, L );
    if features == 0
        features = MFCCs;
    else
        features = [features, MFCCs];
    end
end

files = dir('../Sound Samples/Cleaned Data/Emergency Vehicles/*.wav');
for file=files'
    sound = audioread(strcat('../Sound Samples/Cleaned Data/Emergency Vehicles/',file.name));
    % Feature extraction (feature vectors as columns)
    [ MFCCs, FBEs, frames ] = ...
                    mfcc( sound, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C, L );
    if features == 0
        features = MFCCs;
    else
        features = [features, MFCCs];
    end
end

files = dir('../Sound Samples/Cleaned Data/Honks/*.wav');
for file=files'
    sound = audioread(strcat('../Sound Samples/Cleaned Data/Honks/',file.name));
    % Feature extraction (feature vectors as columns)
    [ MFCCs, FBEs, frames ] = ...
                    mfcc( sound, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C, L );
    if features == 0
        features = MFCCs;
    else
        features = [features, MFCCs];
    end
end
features = features(2:end,:);
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