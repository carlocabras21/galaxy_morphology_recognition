function category = get_category(data_matrix, file_name)
%% GET_CATEGORY returns the category of the image from the data matrix

% get the row where there is the image named "file_name"
i = strcmp(data_matrix.PGC_name, file_name);

% get the morphology type
type = char(data_matrix.type(i));

% print it
% disp(type);

if startsWith(type, 'E') || strcmp(type, 'S0') || startsWith(type, 'S0')
    category = categorical({'elliptic'});
    
elseif startsWith(type, 'S')
    category = categorical({'spiral'});
    
else
    category = categorical({'irregular'});

end