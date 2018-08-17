function [imds_kmeans, trainingFeatures] = ...
    get_imds_kmeans(imds, trainingFeatures, k)
%% GET_IMDS_KMEANS extract the kmeans from the dataset imds

% get the features for each category
elliptic_features = trainingFeatures(:, imds.Labels == 'elliptic');
irregular_features = trainingFeatures(:, imds.Labels == 'irregular');
spiral_features = trainingFeatures(:, imds.Labels == 'spiral');

%% elliptic
disp('  extracting elliptic');
% in 'D' there is the distance from the centroid, which is only 1
[~,~,~,D] = kmeans(elliptic_features', 1);

% get the indices of the ordered distances
[~, minimum_distances_indices] = sort(D,'ascend');

% get only the k indices closest to the centroid
closest_k_indices = minimum_distances_indices(1:k);

% get the features of those closest images
closest_elliptic_features = elliptic_features(:, closest_k_indices);

% create a new datastore with all the elliptic images
elliptic = imageDatastore(cat(1, imds.Files(imds.Labels == 'elliptic')));

% get only the closest images
elliptic.Files = elliptic.Files(closest_k_indices);

% set the Labels
elliptic.Labels = repelem(categorical({'elliptic'}), k);

%% irregular
disp('  extracting irregular');
[~,~,~,D] = kmeans(irregular_features', 1);

[~, minimum_distances_indices] = sort(D,'ascend');
closest_k_indices = minimum_distances_indices(1:k);

closest_irregular_features = irregular_features(:, closest_k_indices);

irregular = imageDatastore(cat(1, imds.Files(imds.Labels == 'irregular')));
irregular.Files = irregular.Files(closest_k_indices);
irregular.Labels = repelem(categorical({'irregular'}), k);

%% spiral
disp('  extracting spiral');
[~,~,~,D] = kmeans(spiral_features', 1);

[~, minimum_distances_indices] = sort(D,'ascend');
closest_k_indices = minimum_distances_indices(1:k);

closest_spiral_features = spiral_features(:, closest_k_indices);

spiral = imageDatastore(cat(1, imds.Files(imds.Labels == 'spiral')));
spiral.Files = spiral.Files(closest_k_indices);
spiral.Labels = repelem(categorical({'spiral'}), k);


%% creation of the dataset with k images for category
disp('  joining');

imds_kmeans = imageDatastore(cat(1, elliptic.Files, irregular.Files, ...
    spiral.Files));
imds_kmeans.Labels = cat(1,elliptic.Labels, irregular.Labels, ...
    spiral.Labels);

% 
trainingFeatures = [closest_elliptic_features closest_irregular_features ...
    closest_spiral_features];

disp('...done');
end