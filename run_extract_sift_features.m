% Extract SIFT features from each frame's RGB and Depth image.
addpath('common/');
Consts;
Params;

OVERWRITE = true;

[~, sz] = get_projection_mask(consts.level);
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
sampleMask = get_sample_grid(sz(1), sz(2), ...
    params.sift.gridMargin, params.sift.stride);
[Y, X] = ind2sub(size(sampleMask), find(sampleMask));
coords = [X(:) Y(:)];

if ~exist(consts.siftDir, 'dir')
  mkdir(consts.siftDir);
end

%%
for ii = 1 : consts.numImages
  fprintf('Extracting SIFT descriptors %d/%d.\n', ii, consts.numImages);
  if ~consts.useImages(ii)
    continue;
  end
  %提取的每一个点的sift特征都是128维的，且每一幅深度图和对应的RGB图提取的特征点的数量相同
  % Extract from RGB.
  rgbFilename = sprintf(consts.siftRgbFilename, params.sift.patchSize, ...
      params.sift.stride, params.sift.normMethod, ii);
  if ~exist(rgbFilename, 'file') || OVERWRITE
    load(sprintf(consts.imageRgbFilename, ii), 'imgRgb');
    imgGray = rgb2gray(im2double(imgRgb));
    [features, norms] = extract_sift(imgGray, coords, params.sift);
    save(rgbFilename, 'features', 'coords', 'norms');
  end
  
  depthFilename = sprintf(consts.siftDepthFilename, params.sift.patchSize, ...
      params.sift.stride, params.sift.normMethod, ii);
  if ~exist(depthFilename, 'file') || OVERWRITE
    load(sprintf(consts.imageDepthFilename, ii), 'imgDepth');

    % Make the depth relative.
    imgDepth = imgDepth - min(imgDepth(:));
    imgDepth = imgDepth ./ max(imgDepth(:));

    [features, norms] = extract_sift(imgDepth, coords, params.sift);
    save(depthFilename, 'features', 'coords', 'norms');
  end
end

