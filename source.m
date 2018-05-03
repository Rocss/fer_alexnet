% add all subfolders to the path
folder = fileparts(which(mfilename)); 
addpath(genpath(folder));

% --------------- training ------------------------------------------------

if exist('classifier.mat', 'file') ~= 2

    imdsTrain = imageDatastore(fullfile('data','training'),...
    'IncludeSubfolders',true,'FileExtensions','.png','LabelSource','foldernames');

    imdsTest = imageDatastore(fullfile('data','publicTest'),...
    'IncludeSubfolders',true,'FileExtensions','.png','LabelSource','foldernames');

    net = alexnet; 
    inputSize = net.Layers(1).InputSize;
    
    layer = 'fc7';

    augimdsTrain = augmentedImageDatastore([227, 227, 3],imdsTrain);
    featuresTrain = activations(net,augimdsTrain,layer,'OutputAs','rows');

    augimdsTest = augmentedImageDatastore(inputSize,imdsTest);
    featuresTest = activations(net,augimdsTest,layer,'OutputAs','rows');
    
    YTrain = imdsTrain.Labels;
    YTest = imdsTest.Labels;
    
    classifier = fitcecoc(featuresTrain,YTrain);
    
    YPred = predict(classifier,featuresTest);
    
    accuracy = mean(YPred == YTest);    
else
    load classifier.mat;
end
