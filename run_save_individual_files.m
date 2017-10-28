% Loads the labeled dataset and saves it out to individual files which will
% be easier to deal with.
addpath('common/');
addpath('structure_classes/');
Consts;

% Doublecheck that the dataset is in the right place...
if ~exist(consts.datasetPath, 'file')
  fprintf('Whoops. Is the dataset in the right place?\n');
  fprintf('It should be in the path specified by consts.datasetPath:\n');
  fprintf('  ==>   %s\n', consts.datasetPath');
  error('Couldnt find dataset');
end

%% Load (RGB) 'images' and save them out to disk individually.
if ~exist(consts.imageRgbDir, 'dir')
  mkdir(consts.imageRgbDir);
end

fprintf('\nLoading "images" from disk...');
load(consts.datasetPath, 'images');
fprintf('Done.\n');

for ii = 1 : size(images,4)
  fprintf('Saving rgb image %d/%d.\r', ii, size(images,4));
  imgRgbOrig = images(:,:,:,ii);
  imgRgb = crop_image(imgRgbOrig,0);%此处是原图
  %对原始图片进行多尺度的resize，使用默认的最近邻插值方法，为了避免误差，此处暂时不使用常用的双线性插值
  switch consts.level
      case 0
           save(sprintf(consts.imageRgbFilename, ii), 'imgRgb','imgRgbOrig');
      case 1
           imgRgbOrig=imresize(imgRgbOrig,0.4);
           imgRgb=imresize(imgRgb,0.4);
           save(sprintf(consts.imageRgbFilename, ii), 'imgRgb','imgRgbOrig');
      case 2
           imgRgbOrig=imresize(imgRgbOrig,0.8);
           imgRgb=imresize(imgRgb,0.8);
           save(sprintf(consts.imageRgbFilename, ii), 'imgRgb','imgRgbOrig');
      case 3
           imgRgbOrig=imresize(imgRgbOrig,1.2);
           imgRgb=imresize(imgRgb,1.2);
           save(sprintf(consts.imageRgbFilename, ii), 'imgRgb','imgRgbOrig');
  end
end
fprintf('\n=====================\n');

clear images;

%% Load 'depth' and save them out to disk individually.
if ~exist(consts.imageDepthDir, 'dir')
  mkdir(consts.imageDepthDir);
end

fprintf('\nLoading "depths" from disk...');
load(consts.datasetPath, 'depths');
fprintf('Done.\n');

for ii = 1 : size(depths,3)
  fprintf('Saving depth image %d/%d.\r', ii, size(depths,3));
  imgDepthOrig = depths(:,:,ii);
  imgDepth = crop_image(imgDepthOrig,0);
  %对深度信息也做同样的resize
  imgDepth_level1=imresize(imgDepth,0.4);
  imgDepth_level2=imresize(imgDepth,0.8);
  imgDepth_level3=imresize(imgDepth,1.2);
  switch consts.level
      case 0
           save(sprintf(consts.imageDepthFilename, ii), 'imgDepth', 'imgDepthOrig');
      case 1
           imgDepthOrig=imresize(imgDepthOrig,0.4);
           imgDepth=imresize(imgDepth,0.4);
           save(sprintf(consts.imageDepthFilename, ii), 'imgDepth','imgDepthOrig');
      case 2
           imgDepthOrig=imresize(imgDepthOrig,0.8);
           imgDepth=imresize(imgDepth,0.8);
           save(sprintf(consts.imageDepthFilename, ii), 'imgDepth','imgDepthOrig');
      case 3
           imgDepthOrig=imresize(imgDepthOrig,1.2);
           imgDepth=imresize(imgDepth,1.2);
           save(sprintf(consts.imageDepthFilename, ii), 'imgDepth','imgDepthOrig');
    end
end
fprintf('\n=====================\n');

clear depths;

%% Load 'rawDepth' and save them out to disk individually.
%注意，对于原始的深度信息，我们不做多尺度的处理，因为后续我们可能不会使用到原始的深度信息
%一般我们使用的是处理后的深度信息
if ~exist(consts.imageDepthRawDir, 'dir')
  mkdir(consts.imageDepthRawDir);
end

fprintf('Loading "rawDepths" from disk...');
load(consts.datasetPath, 'rawDepths');
fprintf('Done.\n');

for ii = 1 : size(rawDepths,3)
  fprintf('Saving raw image %d/%d.\r', ii, size(rawDepths,3));
  imgDepthRawOrig = rawDepths(:,:,ii);
  imgDepthRaw = crop_image(imgDepthRawOrig,0);
  save(sprintf(consts.imageDepthRawFilename, ii), 'imgDepthRaw', 'imgDepthRawOrig');
end
fprintf('\n=====================\n');

clear rawDepths;

%% Load (Object) 'labels'.
if ~exist(consts.objectLabelsDir, 'dir')
  mkdir(consts.objectLabelsDir);
end

fprintf('\nLoading "labels" from disk...');
load(consts.datasetPath, 'labels');
fprintf('Done.\n');

for ii = 1 : size(labels,3)
  fprintf('Saving object label image %d/%d.\r', ii, size(labels,3));
  imgObjectLabelsOrig = labels(:,:,ii);
  imgObjectLabels = crop_image(imgObjectLabelsOrig,0);
  save(sprintf(consts.objectLabelsFilename, ii), 'imgObjectLabels', 'imgObjectLabelsOrig');
end
fprintf('\n=====================\n');

%% Instance Labels.
if ~exist(consts.instanceLabelsDir, 'dir')
  mkdir(consts.instanceLabelsDir);
end

fprintf('\nLoading "instances" from disk...');
load(consts.datasetPath, 'instances');
fprintf('Done.\n');

for ii = 1 : size(instances,3)
  fprintf('Saving instance image %d/%d.\r', ii, size(instances,3));
  imgInstanceLabelsOrig = instances(:,:,ii);
  imgInstanceLabels = crop_image(imgInstanceLabelsOrig,0);
  save(sprintf(consts.instanceLabelsFilename, ii), 'imgInstanceLabels', 'imgInstanceLabelsOrig');
end
fprintf('\n=====================\n');

clear instances;

%% Structure Class Labels.
if ~exist(consts.structureLabelsDir, 'dir')
  mkdir(consts.structureLabelsDir);
end

fprintf('Loading "names" from disk...');
load(consts.datasetPath, 'names');
fprintf('Done.\n');

fprintf('\n');
for ii = 1 : size(labels,3)
  fprintf('Saving structure class label image %d/%d.\r', ii, size(labels,3));
  imgStructureLabelsOrig = object2structure_labels(labels(:,:,ii), names);
  imgStructureLabels = crop_image(imgStructureLabelsOrig,0);
  save(sprintf(consts.structureLabelsFilename, ii), 'imgStructureLabels', 'imgStructureLabelsOrig');
end
fprintf('\n=====================\n');

clear labels;
clear names;

