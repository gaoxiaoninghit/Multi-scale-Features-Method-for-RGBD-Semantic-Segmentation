% This script demos evaluation on all the prediction maps in pathPred
% make sure you have corresponding ground truth label maps in pathLab
close all; clc; clear;
consts.level=0;
Consts;
%% Options and paths
VERBOSE = 0;    % to show individual image results, set it to 1
load(consts.splitsPath, 'trainNdxs');
for ii = 1 : consts.numImages
  fprintf('generate true result %d/%d.\n', ...
      ii, consts.numImages);
  if ~consts.useImages(ii)
    continue;
  end
  if isin(ii, trainNdxs)
      continue;
  end
  readFilename = sprintf(consts.structureLabelsFilename, ii);
  load(readFilename,'imgStructureLabels');
  save(sprintf(consts.trueResultFilename,ii),'imgStructureLabels');
end
% path to image(.jpg), prediction(.png) and annotation(.png)
% *NOTE: change these paths while evaluating your own predictions
% pathImg = fullfile('sampleData', 'images');
pathPred = consts.predictResult;
pathAnno =consts.trueResultDir;

addpath(genpath('evaluationCode/'));
addpath(genpath('visualizationCode'));

% number of object classes: 150
numClass = 40; 
% load class names
load('objectName40.mat');
% load pre-defined colors 
% load('color150.mat');
%这里的颜色是预定义的
%% Evaluation
% initialize statistics
cnt=0;
area_intersection = double.empty;
area_union = double.empty;
pixel_accuracy = double.empty;
pixel_correct = double.empty;
pixel_labeled = double.empty;

% main loop
filesPred = dir(fullfile(pathPred, '*.mat'));
filesAnno=dir(fullfile(pathAnno, '*.mat'));
for i = 1: numel(filesPred)
    % check file existence
    filePred = fullfile(pathPred, filesPred(i).name);
    fileLab = fullfile(pathAnno, filesAnno(i).name);
    if ~exist(fileLab, 'file')
        fprintf('Label file [%s] does not exist!\n', fileLab); continue;
    end
    
    % read in prediction and label
    load(filePred,'predictStructureLabels');
    load(fileLab,'imgStructureLabels');
    
    imPred = predictStructureLabels;
    imAnno = imgStructureLabels;
    
    % check image size
    if size(imPred, 3) ~= 1
        fprintf('Label image [%s] should be a gray-scale image!\n', fileLab); continue;
    end
    if size(imPred, 1)~=size(imAnno, 1) || size(imPred, 2)~=size(imAnno, 2)
        fprintf('Label image [%s] should have the same size as label image! Resizing...\n', fileLab);
        imPred = imresize(imPred, size(imAnno));
    end
    
    % compute IoU
    cnt = cnt + 1;
    fprintf('Evaluating %d/%d...\n', cnt, numel(filesPred));
    [area_intersection(:,cnt), area_union(:,cnt)] = intersectionAndUnion(imPred, imAnno, numClass);

    % compute pixel-wise accuracy
    [pixel_accuracy(i), pixel_correct(i), pixel_labeled(i)] = pixelAccuracy(imPred, imAnno);

%     Verbose: show indivudual image results
%     if (VERBOSE)
%         % read image
%         fileImg = fullfile(pathImg, strrep(filesPred(i).name, '.png', '.jpg'));
%         im = imread(fileImg);
%         
%         % plot result
%         plotResult(im, imPred, imAnno, objectNames, colors, fileImg);
%         fprintf('[%s] Pixel-wise accuracy: %2.2f%%\n', fileImg, pixel_accuracy(i)*100.);
%         waitforbuttonpress;
%     end   
end

%% Summary
IoU = sum(area_intersection,2)./sum(eps+area_union,2);
mean_IoU = mean(IoU);
accuracy = sum(pixel_correct)/sum(pixel_labeled);

fprintf('==== Summary IoU ====\n');
for i = 1:numClass
    fprintf('%3d %16s: %.4f\n', i, objectName40{i}, IoU(i));
end
fprintf('Mean IoU over %d classes: %.4f\n', numClass, mean_IoU);
fprintf('Pixel-wise Accuracy: %2.2f%%\n', accuracy*100.);
