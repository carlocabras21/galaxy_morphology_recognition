function feature = get_feature_from_image(path_to_file, net_name, ...
    featuresFolder)
%% GET_FEATURE_FROM_IMAGE returns the feature for that image

% split the path of the file
path_splitted = strsplit(char(path_to_file),'/');

% extract only the name 'something.png'
image_name = char(path_splitted(end));
% split the name from its extension
file_name_splitted = strsplit(image_name,'.');

% concatenate the name with the name of the feature
final_name = [featuresFolder char(file_name_splitted(1)) ...
              '_' net_name '.mat'];

appo = load(final_name);
feature = appo.feature;
end