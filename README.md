# Galaxy Morphology Recognition
Testing some methods for recognize the morphology of a galaxy, based only on the images.

The dataset used is https://www.astromatic.net/projects/efigi, where some features are extracted using the handsonbow code https://sites.google.com/site/handsonbow/downloads ore using the MATLAB tutorials for extracting features from CNN, like this one https://it.mathworks.com/help/vision/examples/image-category-classification-using-deep-learning.html.

This project is part of the Computer Vision course that I'm taking.

We have tested different features like SIFT, DSIFT and MSDSIFT using BoVW from handsonbow; SURF from the BoVW of MATLAB; features extracted with the pre-trained CNNs AlexNet and ResNet50 that are present in MATLAB.

The best results are obtained by trying to recognize three categories (ellitpic, irregular and spiral) and using the AlexNet featues. 

Then, using kmeans for extracting the 336 closest images to the center and using a leave-one-out cross-validation approach, the results were:

kNN

k = 15 (best in 5:5:50)

confusion matrix:

|                    	| actual class 	|            	|           	|        	|
|:------------------:	|:------------:	|------------	|-----------	|--------	|
|    predicted class 	|              	| Elliptical 	| Irregular 	| Spiral 	|
|                    	|  Elliptical  	|     331    	|     13    	|   24   	|
|                    	|   Irregular  	|      0     	|    278    	|    0   	|
|                    	|    Spiral    	|      7     	|     47    	|   314  	|

accuracy = 0.9103

SVM

confusion matrix:

|                    	| actual class 	|            	|           	|        	|
|:------------------:	|:------------:	|------------	|-----------	|--------	|
|    predicted class 	|              	| Elliptical 	| Irregular 	| Spiral 	|
|                    	|  Elliptical  	|     325    	|     5     	|   13   	|
|                    	|   Irregular  	|      0     	|    321    	|    5   	|
|                    	|    Spiral    	|     13     	|     12    	|   320  	|

accuracy = 0.9527

Finally, we have tried to test an augmented dataset, by allowing to have 3016 images in each category. Originally there are ~1100 elliptic images, ~330 irregular images and ~3000 spiral images. The corrispondet augmented images of an image are not used for training the classifier for that particular image. The results were:


kNN

k = 10 (best in 5:5:50)

confusion matrix:

|                    	| actual class 	|            	|           	|        	|
|:------------------:	|:------------:	|------------	|-----------	|--------	|
|    predicted class 	|              	| Elliptical 	| Irregular 	| Spiral 	|
|                    	|  Elliptical  	|    2961    	|    176    	|   39   	|
|                    	|   Irregular  	|     48     	|    2832   	|   11   	|
|                    	|    Spiral    	|      7     	|     8     	|  2966  	|

accuracy = 0.9681

SVM

Elapsed time is 22400.468940 seconds.

confusion matrix:

|                    	| actual class 	|            	|           	|        	|
|:------------------:	|:------------:	|------------	|-----------	|--------	|
|    predicted class 	|              	| Elliptical 	| Irregular 	| Spiral 	|
|                    	|  Elliptical  	|    2941    	|     98    	|    6   	|
|                    	|   Irregular  	|     73     	|    2916   	|    4   	|
|                    	|    Spiral    	|      2     	|     2     	|  3006  	|

accuracy = 0.9796

