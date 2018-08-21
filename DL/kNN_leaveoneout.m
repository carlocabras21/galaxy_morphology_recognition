function [best_k, conf_mat, accuracy] = kNN_leaveoneout(imds, training_features)
%% KNN_LEAVEONEOUT computes the kNN leave-one-out cross-validation

% get the categories present in the imds
% categories = unique(imds.Labels);

% pre-computed array, because I want this order
categories = {'elliptic', 'irregular', 'spiral'};

% get the numbers of images and categories present in the imds
[n_images, ~] = size(imds.Files);
[n_cat, ~] = size(unique(imds.Labels));

% choose the distance
dist = 'eucl';
% dist = 'chi2';

% pre-allocate the distances matrix with very large numbers
distances = realmax('single') * ones(n_images,n_images);

disp('evaluating distances');
lastsize = 0;
fprintf('computing distances for feature ');
tic
for i = 1:n_images
    % print some information
    if mod(i, 200) == 0
        fprintf(repmat('\b', 1, lastsize));
        lastsize = fprintf('%d/%d', i, n_images);
    end
    
    % the i-th feature is the one to test
    test_feature = training_features(:,i);
    
    % the training set is given by the other images, but not the ones
    % from the augmented dataset that correspond to the test image
    [fst, snd] = get_training_set_limits(imds, i,n_images);
    
    % for every image in the training set
    for j = [1:fst snd:n_images]
        % compute the distance between test and training images
        
        trainFeat = training_features(:,j);

        if strcmp(dist, 'eucl')
            distances(i,j) = norm(test_feature - trainFeat);
        else
            distances(i,j) = chi2(test_feature, trainFeat);
        end
    end
end
fprintf("\n");
toc
    
% sort the distances so you can get the k closest
minimum_distances_indices = ones(n_images, n_images);
fprintf("\n");
lastsize = 0;
fprintf('sorting distances for feature ');
tic
for i=1:n_images
    % print some information
    if mod(i, 500) == 0
        fprintf(repmat('\b', 1, lastsize));
        lastsize = fprintf('%d/%d', i, n_images);
    end
    
    % sort the distances and get the indices of the closest distances
    [~, minimum_distances_indices(i,:)] = ...
        sort(distances(i,:),'ascend');
end
fprintf("\n");
toc
    
%% knn

% pre-allocate the variables
conf_mat = zeros(n_cat, n_cat);
accuracy = 0;
best_k = 0;

disp('searching for the best k');
for k=5:5:50
    
    % for each image, get the indices of the k closest images
    knn = minimum_distances_indices(:,1:k); % matrix (n x k)
    
    % for each image, get the k closest image labels
    closest_labels = imds.Labels(knn);

    % for each image, extract the dominant label, which is the predicted 
    % from the kNN
    predicted = mode(closest_labels');

    % pre-allocate the currentconfusion matrix
    curr_conf_mat = zeros(n_cat, n_cat);
    
    % compute the confusion matrix
    for i = 1:n_images
        pred = find(categories == predicted(i));
        actu = find(categories == imds.Labels(i));

        curr_conf_mat(pred, actu) = curr_conf_mat(pred, actu) + 1;
    end
    
    % compute the accuracy
    d = diag(curr_conf_mat);
    curr_accuracy = sum(d)/sum(sum(curr_conf_mat));
    
    % check if we have obtained a better result; if so, save the data
    if curr_accuracy > accuracy
        accuracy = curr_accuracy;
        conf_mat = curr_conf_mat;
        best_k = k;
    end
end


end