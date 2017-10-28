% Performs an initial watershed segmentation on each RGBD image.
addpath(genpath('iccv07Final'));
addpath('segmentation/');
consts.level=0;
Consts;
Params;

OVERWRITE = true;

%%
if ~exist(consts.watershedDir, 'dir')
  mkdir(consts.watershedDir);
end

for ii = 1 : consts.numImages
  if ~consts.useImages(ii)
    continue;
  end
  
  fprintf('Running watershed %d/%d.\n', ii, consts.numImages);
  
  outFilename = sprintf(consts.watershedFilename, ii);
  if exist(outFilename, 'file') && ~OVERWRITE
   continue;
  end

  load(sprintf(consts.imageRgbFilename, ii), 'imgRgb');  
  load(sprintf(consts.planeDataFilename, ii), 'planeData');
  %总结起来就是输出图像的超像素分割，其实只需要一张图像就可以，当然我们这里使用了
  %planeMap对于输出进行了优化，所以得到的超像素区域更加的准确，满足于planeMap的一致性
  [boundaryInfo, pbAll] = im2superpixels(imgRgb, double(planeData.planeMap));
  save(outFilename, 'boundaryInfo', 'pbAll');
end

fprintf('Finished initial watershed segmentation.\n');
