% if the dataset contains augmented images, they must not be used for 
% training. This function returns the limits fo the training set.
% the images must be in alphabetical order.

function [fst, snd] = get_training_set_limits(imds, i, n_images)

% get the file name without the entire path
file_name = get_name_from_path(imds.Files(i));

% remove the '_' character
if contains(file_name, '_')
    file_name = file_name(1, 1:end-2);
end

% set the initial values for the limits
fst = i-1;
snd = i+1;

if i > 1 % if this image is not the first one
    % go back if there are augmented images
    file_name_prec = get_name_from_path(imds.Files(fst));
    while contains(file_name_prec, file_name) && fst > 1
        fst = fst-1;
        file_name_prec = get_name_from_path(imds.Files(fst));
    end
end

if i < n_images % if this image is not the last one
    % go forward if there are augmented images
    file_name_succ = get_name_from_path(imds.Files(snd));
    while contains(file_name_succ, file_name) && snd < n_images
        snd = snd+1;
        file_name_succ = get_name_from_path(imds.Files(snd));
    end
end
end