addpath('common/');
addpath('surfaces/');
addpath('structure_classes/');
addpath(genpath('iccv07Final'));
Consts;
Params;
N=40;
cmap = NYU_v2_labelcolormap(N+1);%要考虑unlabel的数据，对于ublabel数据，我给其赋值为（0，0，0）
load('E:\\学习与研究\\图像研究\\语义分割\\数据集\\NY2_dataset\\labels_objects/labels_000900.mat');
load('E:\\学习与研究\\图像研究\\语义分割\\数据集\\NY2_dataset\\name/names.mat');
imgStructureLabels = object2structure_labels(imgObjectLabels, names);
imshow(imgStructureLabels,cmap);

