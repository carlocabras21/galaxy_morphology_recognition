function imds = get_imds_no_S0()
%% GET_IMDS_NO_S0 returns the imds containing all the images except S0s

% path containing the dataset already splitted and without S0 images
rootFolder = 'galaxies/splitted/filtered_cropped_all_no_S0';

% category types
categories = {'elliptic', 'irregular', 'spiral'};

% extract the imds
imds = imageDatastore(fullfile(rootFolder, categories), ...
    'LabelSource', 'foldernames');

end