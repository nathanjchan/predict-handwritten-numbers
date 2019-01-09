# m-fold cross validation to test k-nearest neighbors
# by Nathan J. Chan
# https://www.nathanjchan.com/
# njc@nathanjchan.com


# uses m-fold cross validation to get approximate error rate of k-nearest neighbors model
# gets the approxiate error rate for k from 1 to 16 and plots it
# this is more of a proof on concept
# the code is super slow and the results are not that interesting, in my opinion
# see knn_run for something cooler


source("knn.R")
library(ggplot2)
set.seed(77)


get_error = function(k, train, distances) {
  # will use knn_cv to determine average error values for a certain k
  msg = paste("calculating average error with k =", k, "...")
  message(msg)
  error = knn_cv(train, distances, k = k)
  return(error)
}


digits_train = read_digits("train.txt")

train = digits_train[sample(nrow(digits_train)), ] # use a randomized up data frame
rows_predict = nrow(digits_train)
rows_all = rows_predict
data_matrix = create_data_matrix(train[1, ], train[2:rows_predict, ])

# get the distance matrix
distances = compute_distances(data_matrix, "euclidean", rows_predict, rows_all, subset = FALSE)

# list of errors for each k
errors = lapply(1:16, get_error, train = train, distances = distances)

# put into a format ggplot can recognize
errors = unlist(errors)
errors = data.frame(errors)

# plot errors on ggplot
ggplot(errors) + 
  geom_point(aes(x = 1:16, y = errors)) +
  labs(x = "k-value", y = "Success rate", title = "k-value compared to sucess rate") +
  theme_minimal() +
  theme(plot.title = element_text(size = 12, face = "bold"), 
        text = element_text(family = "Helvetica"))
