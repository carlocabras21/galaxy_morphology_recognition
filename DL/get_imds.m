function imds = get_imds(rootFolder)
%% GET_IMDS returns an ImageDatastore object containing the image and labels

% check if the rootfolder is already splitted by category
dir_files = dir(rootFolder);
[~, n_types] = size(unique(cell2mat(extractfield(dir_files, 'isdir'))));

if n_types == 1  
    % search for categories in the folder
    
    % remove '.' and '..', every file in the directory is a folder
    category_folders = dir_files(3:end);
    
    % get the category names
    categories = cellstr(extractfield(category_folders, 'name'));
        
    % extract the imds
    imds = imageDatastore(fullfile(rootFolder, categories), ...
        'LabelSource', 'foldernames');
else

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
end