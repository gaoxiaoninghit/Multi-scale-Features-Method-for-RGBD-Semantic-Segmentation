% Runs the segmentation pipeline followed by support inference on the
% inferred (bottom-up segmentation) regions.

% Run the entire segmentation pipeline.
run_pipeline_segmentation;

% Creates ground-truth regions from the user-defined labels.
%此处仍然是使用了部分数据（部分图像),主要是提取区域后给区域按照由小到大的顺序打上标签
run_extract_regions_from_labels;

% Extracts SIFT features and create sparse codes for each one.
%对于深度图和RGB都提取了SITF特征
%建立词典的时候使用的是真实图像
for i=0:3
    consts.level=i;
    run_extract_sift_features;
    run_create_dataset_rgbd_sift;%此处得到的是909-1200张图像中处于TrainInx的归为训练集，反之归为测试集
    run_learn_sc_dict_from_sift;
end
% Extract features and train a classifier for structure-class prediction.
run_extract_structure_class_features_seg;
run_create_dataset_structure_class_features_seg;
run_train_structure_class_classifier_seg;

% % Extract features and train a classifier for local support prediction.
% run_extract_support_features_seg;
% run_create_dataset_support_features_seg;
% run_train_support_classifier_seg;

% % Run baseline #1:
% run_train_floor_classifier_seg;
% run_support_inference_image_plane_rules_seg;
% 
% % Run baseline #2:
% run_support_inference_structure_class_rules_seg;
% 
% % Run baseline #3:
% run_support_inference_support_classifier_seg;
% 
% % Run the LP
% run_support_inference_lp_seg;