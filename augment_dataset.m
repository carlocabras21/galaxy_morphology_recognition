% augment the dataset by rotating an image and saving it.
% the dataset must be already in the main_dir folder and in different
% folders based on the image categories.

main_dir = 'DL/galaxies/splitted/filtered';
category = 'elliptic';

imgdir = dir(fullfile(main_dir, category, '*.png'));

[m, ~] = size(imgdir);

crop_start = 64; 
crop_finish = 192;

% for each file in the folder
for i = 1:m
    % load the image
    img_path = [main_dir '/' category '/' imgdir(i).name];
    I = imread(img_path);

    % do a random rotation from 15° to 75° and crop the image
    J = rotate_and_crop(I, 15 + 60*rand, crop_start, crop_finish);
    % save the new rotated-cropped image
    new_img_path = [img_path(1, 1:end-4) '_2.png'];
    imwrite(J, new_img_path);
    
    % do a random rotation from 15° to 75° and crop the image
    J = rotate_and_crop(I, 15 + 60*rand, crop_start, crop_finish);
    % save the new rotated-cropped image
    new_img_path = [img_path(1, 1:end-4) '_3.png'];
    imwrite(J, new_img_path);
 
    
    % now for the original image, crop it and overwrite it
    I_cropped = crop_image_RGB(I, crop_start, crop_finish);
    imwrite(I_cropped, img_path);

end
        

load gong.mat;
sound(y);
