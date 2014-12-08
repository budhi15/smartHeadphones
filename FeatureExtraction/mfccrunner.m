addpath('mfcc/mfcc');
recObj = audiorecorder(22050, 16, 1);
sound = 0;
while 1
    recordblocking(recObj, 1);
    speech = getaudiodata(recObj);
    %[m, i] = max(speech);
    %speech = speech(6800:end);
    %level = mean(abs(speech));
    %newsound = level>0.004;
    %if newsound && ~sound
    %    disp('sound');
    %elseif ~newsound && sound
    %    disp('stopped sound');
    %end
    %sound = newsound;
    %speech = speech;
    
    displayfeatures(speech);
end
