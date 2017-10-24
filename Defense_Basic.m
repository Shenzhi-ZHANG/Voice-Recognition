clear all;

%const definition
frameLen = 256;
inc = 80;
code = zeros(1,4);
%model input
[dataModel,~] = codeInput;
modelPointList = EndPointDetectParaAdjust(dataModel,frameLen,inc);
% [starting,ending,i,nx1_1,nx2_1] = vad_main(dataModel,frameLen,inc);
% modelPointList(1,1) = starting * 80;
% modelPointList(1,2) = ending * 80;
figure
plot(dataModel);
title('Model')
for i = 1:1:size(modelPointList,1)
    line([modelPointList(i,1) modelPointList(i,1)],[-0.5 0.5],'color','k','LineStyle','-');
    line([modelPointList(i,2) modelPointList(i,2)],[-0.5 0.5],'color','k','LineStyle','--');
end

%extract model feature
model = dataModel(modelPointList(1,1):modelPointList(1,2));
%model = filter([1,-0.9375],1,model);
model = model/max(model);
modelFeature = zeros(1,100);
modelSegLen = floor(length(model)/100);
for i = 1:1:100
    modelFeature(i) = sum(abs(model((i-1)*modelSegLen+1:i*modelSegLen)));
end
    
while 1
    %text input
    [dataOrigin,FS]=codeInput();
    VOICELEN = length(dataOrigin);
    endPointList = EndPointDetectParaAdjust(dataOrigin,frameLen,inc);
%     [starting,ending,i,nx1_1,nx2_1] = vad_main(dataOrigin,frameLen,inc);
%     endPointList(1,1) = starting * 80;
%     endPointList(1,2) = ending * 80;
    figure
    plot(dataOrigin);
    title('Input')
    %examin the list
    for i = 1:1:size(endPointList,1)
        line([endPointList(i,1) endPointList(i,1)],[-0.5 0.5],'color','k','LineStyle','-');
        line([endPointList(i,2) endPointList(i,2)],[-0.5 0.5],'color','k','LineStyle','--');
    end

    %extract data feature
    seg = dataOrigin(endPointList(1,1):endPointList(1,2));
    disList = zeros(1,10);
    %seg = filter([1,-0.9375],1,seg);
    seg = seg/max(seg);
    
    %extract feature
    inputFeature = zeros(1,100);
    inputSegLen = floor(length(seg)/100);
    for i = 1:1:100
        inputFeature(i) = sum(abs(seg((i-1)*inputSegLen+1:i*inputSegLen)));
    end
    
    %compute distance
    distance = sum(abs(inputFeature-modelFeature));
    figure(3)
        yPlot = abs(inputFeature-modelFeature);
        plot(yPlot);
    string = sprintf('distance = %f', distance);
    disp(string);
    if(distance>200)
        disp('Match Failed');
    else
        disp('Match Succeeded');
    end
end


