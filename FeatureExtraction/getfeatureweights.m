function [feats, weights] = getfeatureweights(path1, path2)
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
end

