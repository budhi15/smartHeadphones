function data = generatedataset(path)
addpath('../../istft');

features = 0;
wlen = 25;
h = 10;
nfft = wlen;
fs = 44100;

%build array of sounds
files = dir(path);
pindex = strfind(path,'/');
subpath = path(1:pindex(end));
for file=files'
    sound = audioread(strcat(subpath,file.name));
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

data = real(features);
end

