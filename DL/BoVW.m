function [conf_mat, accuracy] = BoVW(trainingSet, testSet)
%% BOVW compute the Bag of Visusal Words using the training and test sets

disp('extracting bag of features');
bag = bagOfFeatures(trainingSet);

disp('training classifier');
categoryClassifier = trainImageCategoryClassifier(trainingSet, bag);

disp('evaluating classifier');
conf_mat = evaluate(categoryClassifier, testSet);

% Compute average accuracy
accuracy = mean(diag(conf_mat));


end