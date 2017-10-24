function distance = DTWTest(featureVecModel, featureVecInput)

[numFrameInput,~] = size(featureVecInput);
[numFrameModel,~] = size(featureVecModel);
vecDim = size(featureVecInput,2);
dis = zeros(numFrameModel,numFrameInput);
disAcc = ones(numFrameModel,numFrameInput) * realmax;
for i = 1:1:numFrameModel
    for j = 1:1:numFrameInput
        %for k = 1:1:16
        %    dis(i,j) = dis(i,j) + abs(featureVecInput(j,k)-featureVecModel(i,k));
        %end
        dis(i,j) = sum(abs(featureVecModel(i,:)-featureVecInput(j,:)));
    end
end
dis = dis / vecDim;
disAcc(1,1) = dis(1,1);
for i = 2:1:numFrameModel
    for j = 1:1:numFrameInput
        d1 = disAcc(i-1,j);
        if(j > 1)
            d2 = disAcc(i-1,j-1);
        else
            d2 = realmax;
        end
        
        if(j > 2)
            d3 = disAcc(i-1,j-2);
        else
            d3 = realmax;
        end
        disAcc(i,j) = dis(i,j) + min([d1, d2, d3]);        
    end
end
distance = disAcc(numFrameModel,numFrameInput);
end

