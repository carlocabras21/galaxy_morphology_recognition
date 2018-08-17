% This script is used only for extracting the bof vector that describes
% an image. Taken directly from the handsonbow code

%% Parameters setting

% descriptors type
% desc_name = 'sift';
% desc_name = 'dsift';
desc_name = 'msdsift';

dataset_dir='galaxies/filtered/med_3x3/cropped/filtered_cropped_all_no_S0';

% FLAGS
do_feat_extraction = 1;
do_split_sets = 1;

do_form_codebook = 1;
do_feat_quantization = 1;

% PATHS
basepath = '..';
wdir = pwd;
libsvmpath = [ wdir(1:end-6) fullfile('lib','libsvm-3.11','matlab')];
addpath(libsvmpath)

% BOW PARAMETERS
max_km_iters = 50; % maximum number of iterations for k-means
nfeat_codebook = 60000; % number of descriptors used by k-means for the codebook generation
norm_bof_hist = 1;

% number of codewords (i.e. K for the k-means algorithm)
nwords_codebook = 500;

% image file extension
file_ext='png';

% Create a new dataset split
file_split = 'split.mat';
if do_split_sets    
    data = create_dataset_for_extraction(fullfile(basepath, 'img', ...
        dataset_dir),file_ext);
    save(fullfile(basepath,'img',dataset_dir,file_split),'data');
else
    load(fullfile(basepath,'img',dataset_dir,file_split));
end
classes = {data.classname}; % create cell array of class name strings

% Extract SIFT features fon training and test images
if do_feat_extraction   
    extract_sift_features(fullfile('..','img',dataset_dir),desc_name)    
end

%% Load pre-computed SIFT features for training images

% The resulting structure array 'desc' will contain one
% entry per images with the following fields:
%  desc(i).r :    Nx1 array with y-coordinates for N SIFT features
%  desc(i).c :    Nx1 array with x-coordinates for N SIFT features
%  desc(i).rad :  Nx1 array with radius for N SIFT features
%  desc(i).sift : Nx128 array with N SIFT descriptors
%  desc(i).imgfname : file name of original image

lasti=1;
for i = 1:length(data)
     images_descs = get_descriptors_files(data,i,file_ext,desc_name,'train');
     for j = 1:length(images_descs) 
        fname = fullfile(basepath,'img',dataset_dir,data(i).classname,images_descs{j});
        fprintf('Loading %s \n',fname);
        tmp = load(fname,'-mat');
        tmp.desc.class=i;
        tmp.desc.imgfname=regexprep(fname,['.' desc_name],'.png');
        desc_train(lasti)=tmp.desc;
        desc_train(lasti).sift = single(desc_train(lasti).sift);
        lasti=lasti+1;
     end
end


%% Build visual vocabulary using k-means %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if do_form_codebook
    fprintf('\nBuild visual vocabulary:\n');

    % concatenate all descriptors from all images into a n x d matrix 
    DESC = [];
    labels_train = cat(1,desc_train.class);
    for i=1:length(data)
        desc_class = desc_train(labels_train==i);
        DESC = vertcat(DESC,desc_class.sift);
    end

    % sample random M (e.g. M=20,000) descriptors from all training descriptors
    r = randperm(size(DESC,1));
    r = r(1:min(length(r),nfeat_codebook));

    DESC = DESC(r,:);

    % run k-means
    K = nwords_codebook; % size of visual vocabulary
    fprintf('running k-means clustering of %d points into %d clusters...\n',...
        size(DESC,1),K)
    % input matrix needs to be transposed as the k-means function expects 
    % one point per column rather than per row

    % form options structure for clustering
    cluster_options.maxiters = max_km_iters;
    cluster_options.verbose  = 1;

    [VC] = kmeans_bo(double(DESC),K,max_km_iters);%visual codebook
    VC = VC';%transpose for compatibility with following functions
    clear DESC;
end


%% K-means descriptor quantization means assignment of each feature

if do_feat_quantization
    fprintf('\nFeature quantization (hard-assignment)...\n');
    for i=1:length(desc_train)  
      sift = desc_train(i).sift(:,:);
      dmat = eucliddist(sift,VC);
      [quantdist,visword] = min(dmat,[],2); 
      % save feature labels
      desc_train(i).visword = visword;
      desc_train(i).quantdist = quantdist;
    end
end

%% Represent each image by the normalized histogram of visual
N = size(VC,1); % number of visual words

for i=1:length(desc_train)
    visword = desc_train(i).visword;
    H = histc(visword, 1:nwords_codebook);
  
    % normalize bow-hist (L1 norm)
    if norm_bof_hist
        H = H/norm(H);
    end
  
    % save histograms
    desc_train(i).bof=H(:)';
end

save(['desc_train_' desc_name '.mat'], 'desc_train');
% save(['desc_train_' desc_name '_no_S0.mat'], 'desc_train');

load gong.mat;
sound(y);

