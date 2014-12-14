wts = round(weights);
hold on
subplot(3,2,1);
imagesc(wts);
subplot(3,2,2);
imagesc(1-wts);
subplot(3,2,3);
imagesc(feats.*repmat(wts,1,13));
subplot(3,2,4);
imagesc(feats.*repmat(1-wts,1,13));
subplot(3,2,5);
imagesc(feats.*repmat(wts,1,13).');
subplot(3,2,6);
imagesc(feats.*repmat(1-wts,1,13).');
hold off