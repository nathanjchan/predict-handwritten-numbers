# Predict Handwritten Numbers

## Intro
Predict handwritten numbers with machine learning coded by hand
- Coded k-nearest-neighbors machine learning algorithm by hand
- Uses cross validation to test different parameters
- Predicts with 95% accuracy

## Purpose
Demonstrates
- Theoretical understanding of machine learning algorithms
- Fluency in R
- Image processing

## Contents
- **knn.R** contains all the functions necessary to run the algorithm

- **knn_best.R** finds the best k-value to use

- **knn_cv.R** uses cross validation to find the approxmiate error rate for each k-value

- **knn_run.R** runs the algorithm, predicting the images in test.txt based on the training data in train.txt

- **test.txt** has testing data, with each line containing a number 0-9 and 256 pixel values which are -1 to 1, -1 meaning pure white and 1 meaning pure black, representing a 16x16 image

- **train.txt** has training data in the same format as the testing data

- **view_image.R** contains functions to view the 16x16 images in R
