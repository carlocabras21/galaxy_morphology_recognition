function J = crop_image_RGB(I, fst, snd)
%% crops the image

% get the single layers
[r,g,b] = separate_RGB(I);

% crop the layers
r_cropped = r(fst:snd, fst:snd);
g_cropped = g(fst:snd, fst:snd);
b_cropped = b(fst:snd, fst:snd);

% get the total image
J = cat(3, r_cropped, g_cropped, b_cropped);

end