% Determines the class and instance labels for each of the initial superpixel segments produced by
% the watershed segmentation.

addpath('common/');
addpath('segmentation/');
consts.level=0;
Consts;

OVERWRITE = true;%高小宁

%%
fprintf('\nRunning regions2labels on superpixels from Watershed:\n');

for ii = 1 : consts.numImages
  if ~consts.useImages(ii)
    continue;
  end
  
  outFilename = sprintf(consts.objectLabelsSegFilename, ii);
  if exist(outFilename, 'file') && ~OVERWRITE
    fprintf('Skipping file %d/%d (already exists).\n', ii, consts.numImages);
    continue;
  end
  
  fprintf('Running regions2labels (%d/%d)\r', ii, consts.numImages);
  
  % 
  load(sprintf(consts.objectLabelsFilename, ii), 'imgObjectLabels');
  load(sprintf(consts.instanceLabelsFilename, ii), 'imgInstanceLabels');

  load(sprintf(consts.watershedFilename, ii), 'boundaryInfo');
  
  [instanceMasks, instanceLabels] =  get_instance_masks(imgObjectLabels, imgInstanceLabels);
  [classLabels, instanceLabels, intersectionPcnt] = ...
      regions2labels(boundaryInfo.imgRegions, instanceMasks, instanceLabels);
   %%此处输出的classLabels为每一个超像素赋值了一个类标签，但是instanceLabel表示的是第几个目标（比如只有18个目标，那么其标签就是1...18,）
   %%具体都是根据Mask的重叠度进行计算的，而这个重叠度是一个可以调节的参数，第三个值是IoU
   %%而每一幅图片含有的区域的个数是不一致的大概是1700左右
   save(outFilename, 'classLabels', 'instanceLabels', 'intersectionPcnt');
end

fprintf('\n');
fprintf('===============================\n');
fprintf('Finished running region2labels \n');
fprintf('===============================\n\n');