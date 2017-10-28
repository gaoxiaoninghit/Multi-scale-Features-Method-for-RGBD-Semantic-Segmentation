% Runs the segmentation pipeline followed by support inference on the
% inferred (bottom-up segmentation) regions.

% Run the entire segmentation pipeline.
run_pipeline_segmentation;

% Creates ground-truth regions from the user-defined labels.
run_extract_regions_from_labels;

% Extracts SIFT features and create sparse codes for each one.
run_extract_sift_features;
run_create_dataset_rgbd_sift;
run_learn_sc_dict_from_sift;

% Extract features and train a classifier for structure-class prediction.
run_extract_structure_class_features_seg;
run_create_dataset_structure_class_features_seg;
run_train_structure_class_classifier_seg;
