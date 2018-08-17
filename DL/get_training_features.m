function training_features = get_training_features(imds, feature_type, ... 
    featuresFolder)
%% GET_TRAINING_FEATURES loads the precomputed training features

% get the number of images
[n_images, ~] = size(imds.Files);

rows = 0;

% set the number of rows, i.e. the number of the feature components
if strcmp(feature_type, 'alexnet')
	rows = 4096;
elseif strcmp(feature_type, 'resnet')
    rows = 1000;
elseif strcmp(feature_type, 'bovw_SURF') || ...
        strcmp(feature_type, 'bovw_SIFT') || ...
        strcmp(feature_type, 'bovw_DSIFT') || ...
        strcmp(feature_type, 'bovw_sift') || ...
        strcmp(feature_type, 'bovw_dsift') || ...
        strcmp(feature_type, 'bovw_msdsift') || ...
        strcmp(feature_type, 'bovw_dsift_no_S0')
    rows = 500;
end

% pre-allocate the matrix of the training_features
training_features = zeros(rows, n_images);


fprintf('  loading feature ');
lastsize = 0;
for i = 1:n_images
    % print some information
    if mod(i, 200) == 0              
        fprintf(repmat('\b', 1, lastsize));
         lastsize = fprintf('%d/%d', i, n_images);
%          pause(.05); % allows time for display to update
    end
    
    % load the feature and save it in the matrix
    training_features(:,i) = get_feature_from_image(imds.Files(i), ... 
        feature_type, featuresFolder);
end
fprintf("\n... done.\n");
end