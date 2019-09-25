# k-nearest neighbors
# by Nathan Chan
# https://www.nathanjchan.com/
# nathanjchan2@gmail.com


# uses the k-nearest neighbors machine learning model to predict handwritten digits
# can predict handwritten digits with about 95% accuracy

# the handwritten digits are given as a 16x16 image, written as pixel color values
# uses k = 4 and Euclidean distance, as these are the best, tested parameters for the model
# see the knn_best script for how I determined the k-value

# entire script runs for about two minutes
# the data frame "predicted" will have all the predictions in the third column


source("knn.R")


digits_test = read_digits("test.txt")
digits_train = read_digits("train.txt")

predicted = knn(digits_test, digits_train)
success = success_rate(predicted)

final_message = paste("k-nearest neighbors model predicted with", success, "% success")
message(final_message)
