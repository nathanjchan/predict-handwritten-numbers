Hello! My name is Nathan Chan.
My website is https://www.nathanjchan.com/
My email is njc@nathanjchan.com

This folder contains the R scripts necessary to predict handwritten numbers with 95% accuracy. 
This is a demonstration of the k-nearest neighbors machine learning algorithm in R.

knn.R        - contains all the functions necessary to run the algorithm
knn_best.R   - finds the best k-value to use
knn_cv.R     - uses cross validation to find the approxmiate error rate for each k-value
knn_run.R    - runs the algorithm, predicting the images in test.txt based on the training data in train.txt
test.txt     - each line of these files contains a number 0-9 and 256 pixel values which are -1 to 1,
train.txt         -1 meaning pure white and 1 meaning pure black, representing a 16x16 image
view_image.R - functions to view the 16x16 images in R
             