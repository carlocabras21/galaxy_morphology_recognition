% this script filter and crops the images. It needs that the galaxies are 
% already divided by category and that the folder is the one specified 
% in "main_dir"

main_dir = 'galaxies/png/';

category_dirs = dir(main_dir);
 
%remove '..' and '.' directories
category_dirs(~cellfun(@isempty, regexp({category_dirs.name}, '\.*')))=[];
category_dirs(strcmp({category_dirs.name},'split.mat'))=[]; 

% set the start and the end of the crop
fst = 64;
snd = 192;

% for each category (subfolder) in the main category
for c = 1:length(category_dirs)
    fprintf(1, 'Now filtering %s images\n', category_dirs(c).name);
    if isdir(fullfile(main_dir,category_dirs(c).name)) && ~strcmp(category_dirs(c).name,'.') ...
            && ~strcmp(category_dirs(c).name,'..')
        imgdir = dir(fullfile(main_dir,category_dirs(c).name, '*.png'));

        [m, ~] = size(imgdir);

        % for each file in the folder
        for i = 1:m
            % load the image
            img_path = [main_dir category_dirs(c).name '/' imgdir(i).name];
            I = imread(img_path);
            
            % get the r-g-b components
            r = I(:,:,1);
            g = I(:,:,2);
            b = I(:,:,3);
            
            % median filter
            r_filtered = medfilt2(r, [3 3]);
            g_filtered = medfilt2(g, [3 3]);
            b_filtered = medfilt2(b, [3 3]);
            
            % crop them
            r_cropped = r_filtered(fst:snd, fst:snd);
            g_cropped = g_filtered(fst:snd, fst:snd);
            b_cropped = b_filtered(fst:snd, fst:snd);
            
            % join the r-g-b layers and overwrite the image
            J = cat(3, r_cropped, g_cropped, b_cropped);
            imwrite(J, img_path);
        end
        
    end
end

load gong.mat;
sound(y);

