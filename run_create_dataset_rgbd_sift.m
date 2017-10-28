% Creates a single (giant) dataset of all the SIFT descriptors extracted from the dataset. The
% descriptors are concatenated as per 'Indoor Scene Segmentation using a Structured Light Sensor'.
addpath('common/');
Consts;
Params;
switch consts.level
    case 1
        params.sift.stride = round(params.sift.stride*0.4);
        params.sift.patchSize = round(params.sift.patchSize*0.4);
        params.sift.gridMargin = round(params.sift.gridMargin*0.4);
     case 2
        params.sift.stride = round(params.sift.stride*0.8);
        params.sift.patchSize = round(params.sift.patchSize*0.8);
        params.sift.gridMargin = round(params.sift.gridMargin*0.8);
     case 3
        params.sift.stride = round(params.sift.stride*1.2);
        params.sift.patchSize = round(params.sift.patchSize*1.2);
        params.sift.gridMargin = round(params.sift.gridMargin*1.2);
end
% Setup the sample mask.
[~, sz] = get_projection_mask(consts.level);

% Setup the sample mask.
sampleMask = get_sample_grid(sz(1), sz(2), ...
    params.sift.gridMargin, params.sift.stride);
  
F = nnz(sampleMask);

%% Load each descriptor.
D = 256;
N = consts.numImages;

allFeatures = zeros(N*F, D, 'single');
allNorms = zeros(N*F, 2, 'single');
allCoords = zeros(N*F, 2, 'single');
allImageNdxs = zeros(N*F, 1, 'single');

endNdx = 0;

%%
fprintf('\n');
for ii = 1 : N
  fprintf('Loading sift descriptors (%d/%d)\r', ii, N);
  if ~consts.useImages(ii)
    continue;
  end
  
  % Grab the descriptors.
  siftRgb = load(sprintf(consts.siftRgbFilename, params.sift.patchSize, ...
    params.sift.stride, params.sift.normMethod, ii), ...
      'features', 'coords', 'norms');
  siftD = load(sprintf(consts.siftDepthFilename, params.sift.patchSize, ...
    params.sift.stride, params.sift.normMethod, ii), ...
      'features', 'coords', 'norms');

  rgbdFeatures = [siftRgb.features siftD.features];
  rgbdCoords = siftRgb.coords;
  rgbdNorms = [siftRgb.norms siftD.norms];
  
  % Create the image ndxs.
  imageNdxs = ones(size(siftRgb.features, 1), 1) * ii;
  
  startNdx = endNdx + 1;
  endNdx = startNdx + size(rgbdFeatures, 1) - 1;
  
  allFeatures(startNdx:endNdx, :) = single(rgbdFeatures);
  allCoords(startNdx:endNdx, :) = single(rgbdCoords);
  allNorms(startNdx:endNdx, :) = single(rgbdNorms);
  allImageNdxs(startNdx:endNdx) = single(imageNdxs);
end
fprintf('\n');

% Truncate：此处必须截短，因为之前的之前并未使用全部的图像，但是allFeatures等量的初始化使用的是全部数量的图像。
allFeatures = allFeatures(1:endNdx, :);
allCoords = allCoords(1:endNdx, :);
allImageNdxs = allImageNdxs(1:endNdx);

%% Finally, save it to disk.
outFilename = sprintf(consts.siftDataset, params.sift.patchSize, ...
    params.sift.stride, params.sift.normMethod);
  
load(consts.splitsPath, 'trainNdxs', 'testNdxs');
allTrainIndics = isin(allImageNdxs, trainNdxs);

fprintf('Splitting into train and test...');
trainData = allFeatures(allTrainIndics, :);
testData = allFeatures(~allTrainIndics, :);

trainNorms = allNorms(allTrainIndics, :);
testNorms = allNorms(~allTrainIndics, :);
fprintf('DONE\n');
  
fprintf('Saving SIFT dataset: %s...', outFilename);
save(outFilename, 'trainData', 'testData', ...
    'trainNorms', 'testNorms', '-v7.3');
fprintf('DONE\n');

