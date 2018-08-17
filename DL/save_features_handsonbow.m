% this script saves the features in single files, so that each image has
% the corresponding feature file. The features from handsonbow must be
% in the variable "desc_train" 

% set the feature type
% feature_type = 'dsift_no_S0';
feature_type = 'msdsift';

% load the file containing the "desc_train" variable
% load(['../handsonbow/matlab/desc_train_' feature_type '.mat']);

% get the number of images and feature components
[~, n_images] = size(desc_train);
[~, n_components] = size(desc_train(1).bof);

% get the name of the file
names = extractfield(desc_train, 'imgfname');

% get the bof vectors and store them in a matrix (n_components x n_images)
bofs = extractfield(desc_train, 'bof');
bofs = reshape(bofs, [n_components, n_images]);

% folder where to save the features
featuresFolder = 'galaxies/features_filt_crop/';

for i=1:n_images
    % get the name and the feature vecotr
    name = get_name_from_path(names(i));
    feature = bofs(:,i);
    
    % concatenate image name with feature name
    final_name = [featuresFolder name '_bovw_' feature_type '.mat'];
    
    % save the feature
    save(final_name, 'feature');
end