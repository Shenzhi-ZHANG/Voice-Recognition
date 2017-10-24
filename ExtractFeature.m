function [featureVec] = ExtractFeature(dataOrigin)
FS = 8000;
FFTLEN = 1024;
hammingWindow = zeros(1,256);
for i = 1:1:256
    hammingWindow(i) = 0.54-0.46*cos(2*i*3.14159/(256-1));  
end
%compute feature boundary
L = 22;
freqBound = zeros(1,L);
for j=1:1:20
    freqBound(j) = 1960 * (j + 0.53)/(26.81 - j - 0.53);
end
boundList = freqBound(1:17);
dataOrigin = dataOrigin';
numFrame = 1;
%dataTrunc = zeros(1,256);
featureVec = zeros(floor((length(dataOrigin)-256)/80)+1,16);
%for i = 1:256:length(dataOrigin)-256
for i = 1:80:length(dataOrigin)-256;
    dataTrunc = dataOrigin(i:i+255) .* hammingWindow;
    dataTruncFreq = fft(dataTrunc,FFTLEN);
    %plot(f/1000,2*abs(dataTruncFreq(1:256/2+1)))
    %sqSum(numFrame) = sqrt(sum(dataTrancFreq.*dataTrancFreq));
    for j=1:1:16
        for k=max(floor(FFTLEN*boundList(j)/FS),1) : 1 : floor(FFTLEN*boundList(j+1)/FS)
            featureVec(numFrame,j) = featureVec(numFrame,j) + abs(dataTruncFreq(k)) * abs(dataTruncFreq(k));
        end
    end
    featureVec(numFrame,:) = sqrt(featureVec(numFrame,:));
    numFrame = numFrame + 1;
 end

