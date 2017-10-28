% Trains several stages of boundary classifiers
addpath('common/');
addpath('segmentation/');
addpath(genpath('iccv07Final'));
consts.level=0;
Consts;
Params;

params.overwrite = true;%高小宁
params.seg.featureSet = consts.BFT_RGBD;

% Load the train/test split.
load(consts.splitsPath, 'trainNdxs');

if ~exist(consts.boundaryFeaturesDir, 'dir')
  mkdir(consts.boundaryFeaturesDir);
end
%此处改为并行计算
for stage = 1 : params.seg.numStages  %高小宁 1——>2
  %%并不是对所有的图片都提取了边界分类器特征（只对use image:909--1200)、
  %%watershedFile中包含了boundaryInfo和pbAll两种信息
  %% 其中
  %%[boundaryFeatures, boundaryLabels] = get_boundary_classifier_features( 
  %%ii, imgRgb, planeData, boundaryInfo, pbAll, instanceLabels, params);
  %输入extract_boundary_classifier_features_and_labels中的函数，是一个核心问题，是可以进行更改的
  extract_boundary_classifier_features_and_labels(stage, params);

  %% Create the boundary-classification dataset.
  datasetFilename = sprintf(consts.boundaryFeaturesDataset, ...
      params.seg.featureSet, stage);
    
  %下面产生的训练集与测试集只有部分数据，并不少全部图像生成的边界特征
  if ~exist(datasetFilename, 'file') || params.overwrite
    [trainData, testData, trainLabels, testLabels] = ...
        create_boundary_classifier_dataset(stage, trainNdxs, params.seg.featureSet);
    fprintf('Saving dataset...');
    save(datasetFilename, 'trainData', 'trainLabels', ...
        'testData', 'testLabels', '-v7.3');
    fprintf('DONE\n');
  else
    fprintf('Loading the boundary-classification dataset.\n');
    load(datasetFilename, 'trainData', 'trainLabels', ...
      'testData', 'testLabels');
  end

  %% Train the boundary classifier.
  boundaryClassifierFilename = ...
      sprintf(consts.boundaryClassifierFilename, params.seg.featureSet, stage);

  if ~exist(boundaryClassifierFilename, 'file') || params.overwrite
    classifier = train_boundary_classifier_dt(stage, trainData, trainLabels, ...
        testData, testLabels, params);
    save(boundaryClassifierFilename, 'classifier');
  else
    fprintf('Skipping creation of boundary classifier for stage %d\n', stage);
    load(boundaryClassifierFilename, 'classifier');
  end

  %%
  fprintf('Performing merges:\n');
  for ii = 1 : consts.numImages
    fprintf('Merging regions (Image %d/%d, stage %d).\r', ...
        ii, consts.numImages, stage);

    if ~consts.useImages(ii)
      continue;
    end
    %加info的是后处理的边界文件
    outFilename = sprintf(consts.boundaryInfoPostMerge, ...
          params.seg.featureSet, stage, ii);
    if exist(outFilename, 'file') && ~params.overwrite
      continue;
    end

    load(sprintf(consts.planeDataFilename, ii), 'planeData');
    load(sprintf(consts.watershedFilename, ii), 'pbAll');
    %%如果是stage1,则使用watershed..mat，否则使用info_.._stage-1..mat
    if stage == 1
      boundaryInfoFilename = sprintf(consts.watershedFilename, ii);
    else
      boundaryInfoFilename = sprintf(consts.boundaryInfoPostMerge, ...
          params.seg.featureSet, stage-1, ii);
    end
    
    load(boundaryInfoFilename, 'boundaryInfo');
    load(sprintf(consts.imageRgbFilename, ii), 'imgRgb');
    load(sprintf(consts.objectLabelsFilename, ii), 'imgObjectLabels');
    load(sprintf(consts.instanceLabelsFilename, ii), 'imgInstanceLabels');
    load(sprintf(consts.boundaryFeaturesFilename, ...
        params.seg.featureSet, stage, ii), 'boundaryFeatures');
    
    [~, instanceLabels] = get_labels_from_instances(boundaryInfo.imgRegions, ...
        imgObjectLabels, imgInstanceLabels);
    
    result = merge_regions(boundaryInfo, boundaryFeatures, ...
        classifier, stage, params);
    boundaryInfo = update_boundary_info(boundaryInfo, result, imgRgb);
    save(outFilename, 'boundaryInfo');
  end

  fprintf('\n');
  fprintf('======================================\n');
  fprintf('Finished merging regions for stage %d!\n', stage);
  fprintf('======================================\n');
end
