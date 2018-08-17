function imds = get_imds(rootFolder)
%% GET_IMDS returns an ImageDatastore object containing the image and labels

% load images
imds = imageDatastore(fullfile(rootFolder));
[n_images, ~] = size(imds.Files);

% load data matrix from file
M = importfile('data.tsv');

% pre-compute an array of other elements
imds.Labels = repelem(categorical({'other'}), n_images);

for i=1:n_images
    name = get_name_from_path(imds.Files(i));
    
    % set the correct category
    imds.Labels(i) = get_category(M, name); 
end

end