function J = rotate_and_crop(I, angle, crop_start, crop_finish)
%% rotates and crops the image

J = imrotate(I, angle, 'bilinear', 'crop');
J = crop_image_RGB(J, crop_start, crop_finish);

end