%% Example of how to use this code

%% Images Loading
% set the images path
rootFolder = 'galaxies/splitted/filtered_cropped_augmented';

is_augmented = contains(rootFolder, 'augmented');

% load images
disp('loading images');
imds = get_imds(rootFolder);

% "S0" galaxies are the most mis-evaluated from the classifiers, so this
% test works without using them
% imds = get_imds_no_S0;

%% Features Loading
feature_type = 'alexnet';
% feature_type = 'resnet';
% feature_type = 'bovw_SIFT';
% feature_type = 'bovw_sift';
% feature_type = 'bovw_msdsift';
% feature_type = 'bovw_dsift';
% feature_type = 'bovw_dsift_no_S0';
% feature_type = 'bovw_SURF';

featuresFolder = 'galaxies/features_filt_crop/';

do_extraction = 1;
if do_extraction
    % extract and save features
    disp(['extracting ' feature_type ' features']);
    trainingFeatures = extract_save_features(imds, feature_type, featuresFolder);
else
    % load features (previously extracted)
    disp(['loading ' feature_type ' features']);
    trainingFeatures = get_training_features(imds, feature_type, featuresFolder);
end

%% k-means extraction
% extract kmeans dataset
disp('extracting kmeans');
k = 287; % k dimension
[imds_kmeans, trainingFeatures] = get_imds_kmeans(imds, trainingFeatures, k);

%% Classification
% kNN results
disp('kNN');
% [k, conf_mat, accuracy] = kNN_leaveoneout(imds_kmeans, trainingFeatures)
[k, conf_mat, accuracy] = kNN_leaveoneout(imds, trainingFeatures)

% SVM results
% [conf_mat, accuracy] = SVM(imds_kmeans, trainingFeatures)
[conf_mat, accuracy] = SVM(imds, trainingFeatures)

%% save kmeans image names into file
% these names will be used for the purpose of copy the images in another
% folder, where the handsonbow code can be used

% do_image_saving = 0;
% 
% if do_image_saving
%     [n_images, ~] = size(imds_kmeans.Files);
%     image_names = char(imds_kmeans.Files);
% 
%     fileID = fopen(['image_names_' feature_type '.txt'],'w');
% 
%     for i=1:n_images
%         fprintf(fileID, "%s\n", image_names(i,:));
%     end
% 
%     fclose(fileID);
% end
% 
% % cat ../image_names_bovw_dsift.txt | xargs cp -t images_kmeans_dsift/
% 

%% Bag of Visual Words

% % split dataset and use 80% for training and 20% for test
% disp('splitting dataset');
% [trainingSet, validationSet] = splitEachLabel(imds_kmeans, 0.8, 'randomize');
% 
% [conf_mat, accuracy] = BoVW(trainingSet, validationSet)
% 
% 
% disp('10-fold cross validation');
% [conf_matricies, accuracies] = BoVW_10_fold(imds_kmeans);
% avg_accuracy = mean(accuracies)
% 

%% test for S0
% [n_images, ~] = size(imds_kmeans.Files);
% M = importfile('data.tsv');
% 
% fprintf('\n');
% for i=1:n_images
%     name = get_name_from_path(imds_kmeans.Files(i));
%     imds_kmeans.Labels(i) = get_category(M, name); 
% end


