% Learns a dictionary of atoms used for sparse coding SIFT descriptors.
addpath('common/');
Consts;
Params;

addpath(consts.spamsPath);
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
%% Load the SIFT descriptor dataset.
fprintf('Loading SIFT dataset...');
datasetFilename = sprintf(consts.siftDataset, params.sift.patchSize, ...
    params.sift.stride, params.sift.normMethod);
load(datasetFilename, 'trainData');
fprintf('DONE.\n');
  
%%字典的尺寸是1000
fprintf('Learning dictionary of size %d...\n', params.sc.K);
scParams = struct();
scParams.D = rand(size(trainData, 2), params.sc.K);
scParams.mode = 2;

% Constrain the coefficients to be positive.
scParams.posAlpha = 1;
scParams.lambda = params.sc.lambda; % Coefficient for L1 Regularizer.
scParams.lambda2 = 0; % Coefficient for L2 Regularizer.
scParams.iter = 30;

% Max number of threads.
scParams.numThreads = 4;
%稀疏编码就是寻找K个基向量，对于测试的SIFT特征点，就可以采用这K个基向量的稀疏线性组合方式进行表示
D = mexTrainDL(trainData', scParams);
fprintf('DONE.\n');

%%
fprintf('Saving dictionary...');
save(sprintf(consts.siftDictionary, params.sift.patchSize, ...
    params.sift.stride, params.sift.normMethod, ...
    params.sc.K, params.sc.lambda), 'D');
fprintf('DONE.\n');

