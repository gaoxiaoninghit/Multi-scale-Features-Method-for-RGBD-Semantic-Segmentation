% Contains the constants used throughout the project.
% Where the labeled data is stored.\
consts.datasetDir = 'E:\\学习与研究\\图像研究\\语义分割\\数据集\\NY2_dataset\\';

% Absolute path to the dataset.
consts.datasetPath = [consts.datasetDir 'nyu_depth_v2_labeled.mat'];

% The absolute path to the train/test split.
consts.splitsPath = [consts.datasetDir 'splits.mat'];

% The absolute path to the SPAMS framework:
%   http://spams-devel.gforge.inria.fr/
consts.spamsPath = 'E:\\学习与研究\\图像研究\\语义分割\\code\\NY2\\indoor_scene_seg_sup\\spams-matlab\\build\\';

% Whether or not to use Gurobi. If useGurobi is false, then Matlab's
% built-in LP solver (linprog) will be used.
consts.useGurobi = false;

% The absolute path to Gurobi:
%   http://www.gurobi.com
% consts.gurobiPath = '~/code1/gurobi/latest/linux64/matlab/';

% Absolute path to the Support Labels.
consts.supportLabels = [consts.datasetDir 'support_labels.mat'];

% The total number of images in the dataset.
consts.numImages = 1449;

%%在提取表面法线的时候，只使用的部分数据：909-1200 高小宁注
%这次使用全部数据
consts.useImages = false(consts.numImages, 1);
consts.useImages(1:1449) = true;%先使用300张图片做测试

%%%%%%%%%%
% Images %
%%%%%%%%%%

% Directory in which the RGB images are stored.
consts.imageRgbDir = [consts.datasetDir 'images_rgb/'];

% Directory in which the depth images are stored.
consts.imageDepthDir = [consts.datasetDir 'images_depth/'];

% Directory in which the raw depth images are stored.
consts.imageDepthRawDir = [consts.datasetDir 'images_depth_raw/'];

% Directory in which the object labels are stored.
consts.objectLabelsDir = [consts.datasetDir 'labels_objects/'];
consts.predictResult=[consts.datasetDir 'predictResult/'];
% Filename for each image's object labels. To use:
%   load(sprintf(consts.objectLabelsFilename, imageNum), ...
%       'imgObjectLabels');
consts.predictResultFilename=[consts.predictResult 'predictStructureLabel_%06d.mat'];
consts.objectLabelsFilename = [consts.objectLabelsDir 'labels_%06d.mat'];
consts.objectLabelsSegFilename = [consts.objectLabelsDir 'labels_seg_%06d.mat'];

% Directory in which the instance labels are stored.
consts.instanceLabelsDir = [consts.datasetDir 'labels_instances/'];

% Filename for each image's instance labels. To use:
%   load(sprintf(consts.instanceLabelsFilename, imageNum), ...
%       'imgInstanceLabels');
consts.instanceLabelsFilename = [consts.instanceLabelsDir 'labels_%06d.mat'];

% Directory in which the structure labels are stored.
consts.structureLabelsDir = [consts.datasetDir 'labels_structure/'];
consts.trueResultDir= [consts.datasetDir 'trueResult/'];
% Filename for each image's structure labels. To use:
%   load(sprintf(consts.structureLabelsFilename, imageNum), ...
%       'imgStructureLabels');
consts.structureLabelsFilename = [consts.structureLabelsDir 'labels_%06d.mat'];
consts.trueResultFilename=[consts.trueResultDir 'labels_%06d.mat'];
% Directory in which the ground truth regions (segmentations) are stored.
consts.imageRegionsDir = [consts.datasetDir 'regions/'];

% Filename for each image's ground truth region map. To use:
%   load(sprintf(consts.imageRegionsFilename, imageNum), 'imgRegions');
consts.imageRegionsFilename = [consts.imageRegionsDir 'regions_from_labels_%06d.mat'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feature related constants %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
consts.siftDir = [consts.datasetDir 'sift/'];
consts.siftDataset = [consts.siftDir 'sift_dataset_ps%d_st%d_nm%d.mat'];
consts.siftDictionary = [consts.siftDir 'sift_sc_dict_ps%d_st%d_nm%d_K%d_lambda%2.2f.mat'];
consts.surfaceNormalDataDir = [consts.datasetDir 'surface_normals/'];
switch consts.level
    case 0
        consts.surfaceNormalData = [consts.surfaceNormalDataDir 'surface_normals_%06d.mat'];
        % Filename for each RGB image. To use: 
        %   load(sprintf(consts.imageRgbFilename, imageNum), 'imgRgb');
        consts.imageRgbFilename = [consts.imageRgbDir 'rgb_%06d.mat'];
        % Filename for each raw depth image. To use:
        %   load(sprintf(consts.imageDepthRawFilename, imageNum), 'imgDepthRaw');
        consts.imageDepthRawFilename = [consts.imageDepthRawDir 'depth_raw_%06d.mat'];
        % Filename for each depth image. To use:
        %   load(sprintf(consts.imageDepthFilename, imageNum), 'imgDepth');
        consts.imageDepthFilename = [consts.imageDepthDir 'depth_%06d.mat'];
        consts.siftRgbFilename = [consts.siftDir 'sift_rgb_ps%d_st%d_nm%d_%06d.mat'];
        consts.siftDepthFilename = [consts.siftDir 'sift_depth_ps%d_st%d_nm%d_%06d.mat'];
    case 1
        consts.surfaceNormalData = [consts.surfaceNormalDataDir 'surface_normals_%06d_level1.mat'];
        consts.imageRgbFilename = [consts.imageRgbDir 'rgb_%06d_level1.mat'];
        consts.imageDepthRawFilename = [consts.imageDepthRawDir 'depth_raw_%06d_level1.mat'];
        consts.imageDepthFilename = [consts.imageDepthDir 'depth_%06d_level1.mat'];
        consts.siftRgbFilename = [consts.siftDir 'sift_rgb_ps%d_st%d_nm%d_%06d_level1.mat'];
        consts.siftDepthFilename = [consts.siftDir 'sift_depth_ps%d_st%d_nm%d_%06d_level1.mat'];
    case 2
        consts.surfaceNormalData = [consts.surfaceNormalDataDir 'surface_normals_%06d_level2.mat'];
        consts.imageRgbFilename = [consts.imageRgbDir 'rgb_%06d_level2.mat'];
        consts.imageDepthRawFilename = [consts.imageDepthRawDir 'depth_raw_%06d_level2.mat'];
        consts.imageDepthFilename = [consts.imageDepthDir 'depth_%06d_level2.mat'];
        consts.siftRgbFilename = [consts.siftDir 'sift_rgb_ps%d_st%d_nm%d_%06d_level2.mat'];
        consts.siftDepthFilename = [consts.siftDir 'sift_depth_ps%d_st%d_nm%d_%06d_level2.mat'];
    case 3
        consts.surfaceNormalData = [consts.surfaceNormalDataDir 'surface_normals_%06d_level3.mat'];
        consts.imageRgbFilename = [consts.imageRgbDir 'rgb_%06d_level3.mat'];
        consts.imageDepthRawFilename = [consts.imageDepthRawDir 'depth_raw_%06d_level3.mat'];
        consts.imageDepthFilename = [consts.imageDepthDir 'depth_%06d_level3.mat'];
        consts.siftRgbFilename = [consts.siftDir 'sift_rgb_ps%d_st%d_nm%d_%06d_level3.mat'];
        consts.siftDepthFilename = [consts.siftDir 'sift_depth_ps%d_st%d_nm%d_%06d_level3.mat'];
end

consts.planeDataDir = [consts.datasetDir 'planes/'];
consts.planeDataFilename = [consts.planeDataDir 'plane_data_%06d.mat'];


consts.structureFeaturesDir = [consts.datasetDir 'structure_class_features/'];
consts.structureFeaturesFilename = [consts.structureFeaturesDir 'features_src%d_set%d_stage%d_%06d.mat'];
consts.structureFeaturesDataset = [consts.structureFeaturesDir 'dataset_src%d_set%d_stage%d.mat'];
consts.structureClassifier = [consts.structureFeaturesDir 'classifier_src%d_set%d_stage%d.mat'];

consts.floorClassifier = [consts.structureFeaturesDir 'floor_classifier_src%d_stg%d.mat'];

%%%%%%%%%%%%%%%%%%%%%%%%%
% Support-related files %
%%%%%%%%%%%%%%%%%%%%%%%%%

consts.supportFeaturesDir = [consts.datasetDir 'support/'];
consts.supportFeaturesGeometry = [consts.supportFeaturesDir 'features_geo_src%d_set%d_stg%d_%06d.mat'];
consts.supportFeaturesContainment = [consts.supportFeaturesDir 'features_con_src%d_set%d_stg%d_%06d.mat'];
consts.supportFeaturesHorz = [consts.supportFeaturesDir 'features_horz_src%d_set%d_stg%d_%06d.mat'];
consts.supportDataset = [consts.supportFeaturesDir 'dataset_src%d_set%d_stg%d.mat'];
consts.supportClassifier = [consts.supportFeaturesDir 'classifier_src%d_set%d_stg%d_res%d_rat%d.mat'];

%%%%%%%%%%%%%%%%%%%%%%%%%%
% Segmentation Constants %
%%%%%%%%%%%%%%%%%%%%%%%%%%

consts.watershedDir = [consts.datasetDir 'watershed/'];
consts.watershedFilename = [consts.watershedDir 'watershed_%06d.mat'];

consts.boundaryFeaturesDir = [consts.datasetDir 'boundary_features/'];
consts.boundaryFeaturesFilename = [consts.boundaryFeaturesDir 'type%d_stg%d_%06d.mat'];
consts.boundaryFeaturesDataset = [consts.boundaryFeaturesDir 'dataset_type%d_stg%d.mat'];
consts.boundaryInfoPostMerge = [consts.boundaryFeaturesDir 'info_type%d_stg%d_%06d.mat'];
consts.boundaryClassifierFilename = [consts.boundaryFeaturesDir 'classifier_type%d_stg%d.mat'];
consts.boundaryClassifierPlotFilename = [consts.boundaryFeaturesDir 'classifier_roc_type%d_stg%d.png'];

%%%%%%%%%%%
% Results %
%%%%%%%%%%%

% Directory in which support inference results are stored.
consts.resultsDir = [consts.datasetDir 'results/'];

% Filename for results of support inference using Baseline #1: Image Plane
% Rules. To use:
%   load(sprintf(consts.resultsImgFilename, imageNum), ...
%       'supportLabelsPred');
consts.resultsImgFilename = [consts.resultsDir 'src%d_img_%06d.mat'];

% Filename for results of support inference using Baseline #2: Structure
% Class Rules. To use:
%   load(sprintf(consts.resultsStrFilename, imageNum), ...
%       'supportLabelsPred', 'M');
consts.resultsStrFilename = [consts.resultsDir 'src%d_str_%06d.mat'];

% Filename for results of support inference using Baseline #3: Support
% Classifier. To use:
%   load(sprintf(consts.resultsSupFilename, imageNum), ...
%       'supportLabelsPred');
consts.resultsSupFilename = [consts.resultsDir 'src%d_sup_%06d.mat'];
consts.resultsLpFilename = [consts.resultsDir 'src%d_lp_%06d.mat'];
consts.resultsIpFilename = [consts.resultsDir 'src%d_ip_%06d.mat'];

% Regions may be obtained via the ground truth object and instance labels
% or from a bottom up segmentation.
consts.REGION_SRC_LABELS = 0;
consts.REGION_SRC_BOTTOM_UP = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Boundary Feature Type constants are used to select different sets of
% features when performing segmentation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Use RGB-features only.
consts.BFT_RGB = 1;

% Use depth-features only.
consts.BFT_D = 2;

% Use both RGB and depth features.
consts.BFT_RGBD = 3;

% Use RGB, depth and support features.
consts.BFT_RGBD_SUP = 4;

% Use RGB, depth, support features and structure class features.
consts.BFT_RGBD_SUP_SC = 5;

%structure class names,N=40
consts.wall=1;
consts.floor=2;
consts.cabinet = 3;
consts.bed = 4;
consts.chair = 5;
consts.sofa = 6;
consts.table=7;
consts.door=8;
consts.window = 9;
consts.bookshelf = 10;
consts.picture = 11;
consts.counter = 12;
consts.blinds=13;
consts.desk=14;
consts.shelves = 15;
consts.curtain = 16;
consts.dresser = 17;
consts.pillow = 18;
consts.mirror=19;
consts.floor_mat=20;
consts.clothes = 21;
consts.ceiling = 22;
consts.books = 23;
consts.fridge = 24;
consts.tv=25;
consts.paper=26;
consts.towel = 27;
consts.shower_curtain = 28;
consts.box = 29;
consts.whiteboard = 30;
consts.person=31;
consts.night_stand=32;
consts.toilet = 33;
consts.sink = 34;
consts.lamp = 35;
consts.bathtub = 36;
consts.bag=37;
consts.other_structure=38;
consts.other_furniture=39;
consts.other_prop=40;
consts.void=41;
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Support Inference Types %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
consts.SUP_INF_IMG_PLN_RULES = 1;
consts.SUP_INF_STR_CLS_RULES = 2;
consts.SUP_INF_LCL_CLASSIFIER = 3;
consts.SUP_INF_LP = 4;
consts.SUP_INF_IP = 5;


% If a region has fewer than this number of pixels, just drop it. This is used primarily in creating
% the final 'ground truth' regions. See run_extract_regions_from_labels.m.
consts.MIN_PIXELS_PER_REGION = 10;

