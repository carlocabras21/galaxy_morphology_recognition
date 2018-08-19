% augment the dataset by rotating an image and saving it.
% the dataset must be already in the main_dir folder and in different
% folders based on the image categories.

main_dir = 'DL/galaxies/splitted/filtered_cropped_augmented';
category = 'irregular';

imgdir = dir(fullfile(main_dir, category, '*.png'));

[m, ~] = size(imgdir);

% compute the maximum number of augmented images for reaching 3016 images
max_augmented = ceil(3016/m);

crop_start = 64; 
crop_finish = 192;

lastsize = 0;
fprintf('augmenting image ');

% for each file in the folder
for i = 1:m
    % print some information
    if mod(i, 20) == 0
        fprintf(repmat('\b', 1, lastsize));
        lastsize = fprintf('%d/%d', i, m);
    end
    % load the image
    img_path = [main_dir '/' category '/' imgdir(i).name];
    I = imread(img_path);
    
    % augment!
    for k=2:max_augmented
        % do a random rotation from 15° to 75° and crop the image
        J = rotate_and_crop(I, 360*rand, crop_start, crop_finish);
        % save the new rotated-cropped image
        new_img_path = [img_path(1, 1:end-4) '_' num2str(k) '.png'];
        imwrite(J, new_img_path);
    end
    
    % now for the original image, crop it and overwrite it
    I_cropped = crop_image_RGB(I, crop_start, crop_finish);
    imwrite(I_cropped, img_path);

end

load gong.mat;
sound(y);

% now launch the script remove_files.scala