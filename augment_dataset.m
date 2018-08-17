% augment the dataset by rotating an image and saving it.
% the dataset must be already in the main_dir folder and in different
% folders based on the image categories.

main_dir = ['/path/to/images/'];

category_dirs = dir(main_dir);
 
%remove '..' and '.' directories
category_dirs(~cellfun(@isempty, regexp({category_dirs.name}, '\.*')))=[];
category_dirs(strcmp({category_dirs.name},'split.mat'))=[]; 

% for each category (subfolder) in the main category
for c = 1:length(category_dirs)
    fprintf(1, 'Now augmenting %s images\n', category_dirs(c).name);
    if isdir(fullfile(main_dir,category_dirs(c).name)) && ~strcmp(category_dirs(c).name,'.') ...
            && ~strcmp(category_dirs(c).name,'..')
        imgdir = dir(fullfile(main_dir,category_dirs(c).name, '*.png'));

        [m, ~] = size(imgdir);

        % for each file in the folder
        for i = 1:m
            % load the image
            img_path = [main_dir category_dirs(c).name '/' imgdir(i).name];
            I = imread(img_path);
            
            % do a random rotation from 15° to 75°
            J_rotated = imrotate(I, 15 + 60*rand, 'bilinear', 'crop');

            % get the r-g-b components
            r = J_rotated(:,:,1);
            g = J_rotated(:,:,2);
            b = J_rotated(:,:,3);
           
            fst = 64;
            snd = 192;
			
			% crop the new image
            r_cropped = r(fst:snd, fst:snd);
            g_cropped = g(fst:snd, fst:snd);
            b_cropped = b(fst:snd, fst:snd);
            
            J_rotated_cropped = cat(3, r_cropped, g_cropped, b_cropped);
            
			% save the new rotated-cropped image
            new_img_path = [img_path(1, 1:end-4) '_a.png'];
            imwrite(J_rotated_cropped, new_img_path);
 			
			% now for the original image, only crop it
			
            % get the r-g-b components
            r = I(:,:,1);
            g = I(:,:,2);
            b = I(:,:,3);
           
            fst = 64;
            snd = 192;

            % crop them
            r_cropped = r(fst:snd, fst:snd);
            g_cropped = g(fst:snd, fst:snd);
            b_cropped = b(fst:snd, fst:snd);

            % join the r-g-b layers and overwrite the original image
            J_cropped = cat(3, r_cropped, g_cropped, b_cropped);
            imwrite(J_cropped, img_path);
            
            
           % do others random rotations
%             J = imrotate(I, 15 + 60*rand, 'bilinear', 'crop');
%             new_img_path = [img_path(1, 1:end-4) '_b.png'];
%             imwrite(J, new_img_path);
%          
%             J = imrotate(I, 15 + 60*rand, 'bilinear', 'crop');
%             new_img_path = [img_path(1, 1:end-4) '_c.png'];
%             imwrite(J, new_img_path);
        end
        
    end
end

load gong.mat;
sound(y);
