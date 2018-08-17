function name = get_name_from_path(path)
%% GET_NAME_FROM_PATH returns the file name from the path passed

% split the path of the file (works on Linux)
path_splitted = strsplit(char(path),'/');

% extract only the name 'name.extension', which is the last one
file_name = char(path_splitted(end));

% split the name from its extension
file_name_splitted = strsplit(file_name,'.');

% get the name
name =  char(file_name_splitted(1));
end