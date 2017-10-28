% Finds major scene surfaces and rotates the entire scene such that the
% floor plane's surface normal points directly up.
addpath('common');
addpath(genpath('iccv07Final'));
addpath(genpath('graph_cuts'));
addpath('surfaces');
consts.level=0;
Consts;

% Whether or not to overwrite the planeData files if they're already found
% on disk.
OVERWRITE = true;

if ~exist(consts.planeDataDir, 'dir')
  mkdir(consts.planeDataDir);
end

%% 产生平面数据
for ii = 1 : consts.numImages
  fprintf('Extracting plane data (%d/%d).\n', ii, consts.numImages);

  if ~consts.useImages(ii)
    continue;
  end
  
  outFilename = sprintf(consts.planeDataFilename, ii);
  if exist(outFilename, 'file') && ~OVERWRITE
    continue
  end
  
  load(sprintf(consts.imageRgbFilename, ii), 'imgRgb');
  load(sprintf(consts.imageDepthFilename, ii), 'imgDepthOrig');
  load(sprintf(consts.imageDepthRawFilename, ii), 'imgDepthRawOrig');
  load(sprintf(consts.surfaceNormalData, ii), 'imgNormals', 'normalConf');
  %内部执行的图分割：其中planeData的一部分数据是由图分割，ransac产生
  %%planeData包含planeMap，normals，supportSurfaces等
  planeData = rgbd2planes(imgRgb, imgDepthOrig, imgDepthRawOrig, ...
      imgNormals, normalConf,consts.level);
    
  save(outFilename, 'planeData');
end
