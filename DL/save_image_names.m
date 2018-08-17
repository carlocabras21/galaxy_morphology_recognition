% this script saves the path of the images in the imds_kmeans.

% get the number of the images
[n_images, ~] = size(imds_kmeans.Files);

% get the image paths in an array of chars
image_names = char(imds_kmeans.Files);

% open the file where the names will be saved
fileID = fopen('image_names.txt','w');

for i=1:n_images
    % write into the file the image path
    fprintf(fileID, "%s\n", image_names(i,:));
end

fclose(fileID);
