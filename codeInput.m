function [dataOrigin,fs] = codeInput(~)
fs = 8000;
recObj = audiorecorder(fs, 16, 1);
disp('Recording Ongoing')
recordblocking(recObj, 2);
disp('Finished Recording')
dataOrigin=getaudiodata(recObj);
%audiowrite( 'SequenceForTest.wav',recData,8000);
%disp('play start')
%play(recObj);
end
