% this script filter the images in the folder. It needs that the galaxies 
% are already divided by categor and that the folder is the one specified 
% in "main_dir"

main_dir = ['/media/carlocabras21/Secondary/uni/quarto_anno/CV/' ...
            'progetto/DL/galaxies/filtered/'];

category_dirs = dir(main_dir);
 
%remove '..' and '.' directories
category_dirs(~cellfun(@isempty, regexp({category_dirs.name}, '\.*')))=[];
category_dirs(strcmp({category_dirs.name},'split.mat'))=[]; 

% for each category (subfolder) in the main category
for c = 1:length(category_dirs)
    fprintf(1, 'Now filtering %s images\n', category_dirs(c).name);
    
    % if it's a directory, remove the "." ".." folders
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
            
            % join the r-g-b layers and overwrite the image
            J = cat(3, r_filtered, g_filtered, b_filtered);
            imwrite(J, img_path);
        end
        
    end
end

load gong.mat;
sound(y);

