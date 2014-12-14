path1 = '../Sound Samples/Cleaned Data/Phone Rings/R*.wav';
path2 = '../Sound Samples/Cleaned Data/Background/B*.wav';
%[feats, weights] = getfeatureweights(path1, path2);
%phonerings = getfeatures('../Sound Samples/Cleaned Data/Phone Rings/R*.wav');
%background = getfeatures('../Sound Samples/Cleaned Data/Background/B*.wav');

%{
data1 = generatedataset(path1);
data2 = generatedataset(path2);
if size(data1,2)>size(data2,2)
subset = randsample(size(data1,2),size(data2,2));
traindata1 = data1(:,subset)/mean(mean(abs(data1)));
traindata2 = data2/mean(mean(abs(data2)));
else
subset = randsample(size(data2,2),size(data1,2));
traindata1 = data1/mean(mean(abs(data1)));
traindata2 = data2(:,subset)/mean(mean(abs(data2)));
end
labels1 = ones(1,size(traindata1,2));
labels2 = ones(1,size(traindata2,2))*2;
data = [traindata1,traindata2];
labels = [labels1,labels2];
num_features = size(data,1);
[W,H] = nnmf(data,num_features);
feats = W;
filter1 = labels == 1;
filter2 = labels == 2;
weights1 = H(:,filter1);
weights2 = H(:,filter2);
totalweights1 = sum(weights1,2);
totalweights2 = sum(weights2,2);
totalweights = totalweights1+totalweights2;
weights = totalweights1./totalweights;
%weights = round(weights);
%}
sound1 = audioread('../Sound Samples/Cleaned Data/Background/B01.wav');
sound2 = audioread('../Sound Samples/Cleaned Data/Phone Rings/R01.wav');
sound = [sound1;sound2];
wlen = 25;
h = 10;
nfft = wlen;
fs = 44100;
[extracted, f, t_stft] = stft(sound, wlen, h, nfft, fs);
extracted = real(extracted);
xwts = feats\extracted;
feats1 = (feats.*repmat(weights,1,size(feats,2))).'*xwts;
feats2 = (feats.*repmat((1-weights),1,size(feats,2))).'*xwts;

[phonesound, t_stft] = istft(feats1, h, nfft, fs);
[backsound, t_stft] = istft(feats2, h, nfft, fs);

hold on
subplot(3,2,1);
imagesc(log(abs(extracted)));
subplot(3,2,2);
plot(sound);
subplot(3,2,3);
imagesc(log(abs(feats1)));
subplot(3,2,4);
plot(phonesound);
subplot(3,2,5);
imagesc(log(abs(feats2)));
subplot(3,2,6);
plot(backsound);
hold off
%}

wavwrite(phonesound,fs,'phonefeatures.wav');
wavwrite(backsound,fs,'backfeatures.wav');