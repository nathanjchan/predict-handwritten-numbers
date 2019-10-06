# finding the best k for k-nearest neighbors for this particular model
# by Nathan Chan
# github.com/nathanjchan
# nathanjchan2@gmail.com


# with this particular data set, determines what is the best k to use


source("knn.R")
library(ggplot2)


k_error = function(k, digits_test, digits_train, distances) {
  msg = paste("calcuting error for k =", k, "...")
  message(msg)
  predicted = knn_modified(digits_test, digits_train, k, distances, 
                           1:nrow(digits_test), 1:nrow(digits_train))
  error = success_rate(predicted)
  return(error)
}


digits_test = read_digits("test.txt")
digits_train = read_digits("train.txt")

data_matrix = create_data_matrix(digits_test, digits_train)
rows_predict = nrow(digits_test)
rows_train = nrow(digits_train)
rows_all = rows_predict + rows_train
distances = compute_distances(data_matrix, "euclidean", rows_predict, rows_all)

errors = lapply(1:16, k_error, digits_test, digits_train, distances)

errors = unlist(errors)
errors = data.frame(errors)

ggplot(errors) + 
  geom_point(aes(x = 1:16, y = errors, color = "Euclidean distance")) +
  labs(x = "k-value", y = "Success rate", title = "k-value compared to sucess rate") +
  theme_minimal() +
  theme(plot.title = element_text(size = 12, face = "bold"), text = element_text(family = "Helvetica"))
