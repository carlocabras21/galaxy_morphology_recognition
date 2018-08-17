function trainingFeatures = extract_save_features(imds, feature_type, ...
    features_folder)
%% EXTRACT_SAVE_FEATURES extractes the features from the images in "imds"

disp('  Setting the ImageDatastore ReadFcn');
imds.ReadFcn = @(filename)readAndPreprocessImage(filename);

[n_images, ~] = size(imds.Files);

if strcmp(feature_type, 'alexnet')
    disp('  Loading AlexNet');
    net = alexnet();

    featureLayer = 'fc7';
    
    disp('  extracting features...');
    tic
    trainingFeatures = activations(net, imds, featureLayer, ...
        'MiniBatchSize', 32, 'OutputAs', 'Columns');
    toc
    disp("... done.");
    
elseif strcmp(feature_type, 'resnet')
    disp('  Loading ResNet');
    net = resnet50();

    featureLayer = 'fc1000';
    
    
    disp('  extracting features...');
    tic
    trainingFeatures = activations(net, imds, featureLayer, ...
        'MiniBatchSize', 32);
    toc
    disp("... done.");
    
    [~, ~, m, n] = size(trainingFeatures);
    
    matrix = zeros(m, n);
    
    for i=1:m
        for j=1:n
            matrix(i,j) = double(trainingFeatures(1,1,i,j));
        end
    end
    
    trainingFeatures = matrix;
    
elseif strcmp(feature_type, 'bovw_SURF')
    
    % there is an error that I don't know how to solve, with this
    % method, apparently, it works.
    % trainingSet is equal to imds.
    [~, trainingSet] = splitEachLabel(imds, 0.000000000001, 'randomize');
    
    disp('  extracting bag of features');
    bag = bagOfFeatures(trainingSet);
    
    disp('  encoding features');
    trainingFeatures = zeros(500, n_images);
    
    for i=1:n_images
        img = imread(char(imds.Files(i)));
        featureVector = encode(bag,img);
        trainingFeatures(:,i) = featureVector';
    end
end

disp('  saving features...');
for i=1:n_images
    
    % get the current feature
    feature = trainingFeatures(:,i);

    % split the path of the file
    path_splitted = strsplit(char(imds.Files(i)),'/');

    % extract only the name 'something.png'
    file_name = char(path_splitted(end));
    % split the name from its extension
    file_name_splitted = strsplit(file_name,'.');

    % concatenate image name with feature name
    final_name = [features_folder char(file_name_splitted(1)) ... 
        '_' feature_type '.mat'];
    save(final_name, 'feature');
end
disp("...done.");

end
























