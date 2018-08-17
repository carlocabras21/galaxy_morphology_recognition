function [conf_mat, accuracy] = SVM(imds, trainingFeatures)
%% SVM computes the linear SVM leave-one-out cross-validation

% get categories from the imds
categories = unique(imds.Labels);

% get number of images and categories
[n_images, ~] = size(imds.Files);
[n_cat, ~] = size(unique(imds.Labels));

% initialize the confusion matrix
conf_mat = zeros(n_cat, n_cat);

disp('training SVM');
lastsize = 0;
fprintf('training SVM for feature \n\n');
tic
for i=1:n_images
    % print the current status
%     if mod(i, 10) == 0
%         fprintf(repmat('\b', 1, lastsize));
%         lastsize = fprintf('%d/%d', i, n_images);
%     end

    
    % test-set is composed only by the current feature
    testFeat = trainingFeatures(:, i);
    % training-set is composed by the other features
    trainFeat = trainingFeatures(:, [1:i-1 i+1:end]);
    
    % get the training labels
    trainingLabels = imds.Labels([1:i-1 i+1:end]);
    
    % train the classifier using the training set
    classifier = fitcecoc(trainFeat, trainingLabels, ...
        'Learners', 'Linear', 'Coding', 'onevsall', ...
        'ObservationsIn', 'columns');
    
    % predict the label of the test feature
    predicted = predict(classifier, testFeat');
    
    % get the coordinates for the confusion matrix
    pred = find(categories == predicted);
    actu = find(categories == imds.Labels(i));
    
    % print the mis-classification
    if pred ~= actu
        fprintf('%s ', get_name_from_path(imds.Files(i)));
        fprintf('actual: %s, predicted: %s\n', imds.Labels(i), predicted); 
    end
    
    % update the confusion matrix
    conf_mat(pred, actu) = conf_mat(pred, actu) + 1;
end
fprintf("\n");
toc

% compute accuracy
d = diag(conf_mat);
accuracy = sum(d)/sum(sum(conf_mat));

fprintf("\n... done.\n");
end