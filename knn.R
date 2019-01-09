# k-nearest neighbors
# by Nathan J. Chan
# https://www.nathanjchan.com/
# njc@nathanjchan.com


# this file contains only the functions necessary for k-nearest neighbors
# see knn_run for an actual demonstration


library(stringr)


split_digits = function(one_line) {
  # takes in a single line containing the digit and the image pixels
  two_strings = str_split(one_line, " ", 2) # 1st string is actual number, 2nd is color values
  two_strings_modified = c()                # simplify the return value
  two_strings_modified[1] = two_strings[[1]][1]
  two_strings_modified[2] = two_strings[[1]][2]
  return(two_strings_modified)
}


read_digits = function(file_path) {
  # takes in a file path for a file with a bunch of digits and puts them into a data frame
  file_contents = readLines(file_path)
  df = lapply(file_contents, split_digits)
  df = as.data.frame(do.call(rbind, df))
  names(df) = c("label", "values")
  df = transform(df, label = as.numeric(as.character(label)))
  return(df)
}


split_numbers = function(numbers) {
  # takes in a string of 256 characters and splits it into a vector of 256 numbers
  number_split = str_split(numbers, " ", 256)
  number_split = sapply(number_split[[1]], function(x) {
    x = as.numeric(x)
    return(x)
  })
  return(number_split)
}


find_mode = function(x) {
  # finds mode; if there are multiple modes, takes the first one
  # https://stackoverflow.com/questions/2547402/
  # is-there-a-built-in-function-for-finding-the-mode
  ux = unique(x)
  return(ux[which.max(tabulate(match(x, ux)))])
}


create_data_matrix = function(predict, train) {
  # gets a data matrix in the following format:
  # 1 row for each image; 256 columns for each pixel value in image
  # will use data matrix later to compute distances between each image
  predict_train = rbind(predict, train)
  data_matrix = predict_train[, 2]
  data_matrix = lapply(data_matrix, function(x) {
    split = split_numbers(x)
    return(split)
  })
  
  rows_all = nrow(predict_train)
  rows_predict = nrow(predict)
  rows_train = nrow(train)
  
  data_matrix = unlist(data_matrix)
  data_matrix = matrix(data_matrix, nrow = rows_all, ncol = 256, byrow = TRUE)
  return(data_matrix)
}


compute_distances = function(data_matrix, metric, rows_predict, rows_all, subset = TRUE) {
  # given the data matrix, computes the distance matrix
  # also takes in row counts for subsetting the distance matrix
  # prediction images are rows and training images are columns
  distances = dist(data_matrix, method = metric)
  distances = as.matrix(distances)
  if (subset == TRUE) {
    distances = distances[1:rows_predict, (rows_predict + 1):rows_all]
  }
  return(distances)
}


find_i_min = function(i, row, train) {
  # finds ith min in the row and determine what handwritten number it corresponds with
  min = sort(row, partial = i)[i] # find the min
  guess_index = which(row == min) # find index of min
  guess = train[guess_index, 1]   # find handwritten number that corresponds to index
  return(guess)
}


find_k_min = function(row, k, train) {
  # 1 row for 1 image to predict: each item in row is a distance to a training image
  # works for any given k
  # need training data frame to reference the index to get the actual value
  guesses = sapply(1:k, find_i_min, row = row, train = train)
  prediction = find_mode(guesses) # find which numbers are closest
  return(prediction)
}


knn = function(predict, train, k = 4, metric = "euclidean") {
  # predict and train are data frames
  # will use k = 4 and Euclidean distance
  # runs the algorithm and returns predict data frame with predictions

  data_matrix = create_data_matrix(predict, train)
  
  rows_predict = nrow(predict)
  rows_all = nrow(predict) + nrow(train)
  distances = compute_distances(data_matrix, metric, rows_predict, rows_all)
  
  predictions = apply(distances, 1, find_k_min, k = k, train = train)
  predict_new = cbind(predict, predictions)
  return(predict_new)
}


success_rate = function(predict) {
  # Gives percentage of success given the predicted data frame
  total = nrow(predict)
  check = sum(predict$label == predict$predictions)
  percentage = check / total
  return(percentage)
}


knn_modified = function(predict, train, k = 4, distances, indices_predict, indices_train) {
  # modified version of predict_knn...
  # takes in an already created distance matrix, so we only need to do that computation once
  # also takes in indices to trim predict, train, and distances
  
  indices_predict = unlist(indices_predict)
  indices_train = unlist(indices_train)
  
  predict = predict[indices_predict, ] # m-fold means we look at certain parts at a time
  train = train[indices_train, ]       # need to trim both data frames to only what we need
  distances = distances[indices_predict, indices_train]
  
  predictions = apply(distances, 1, find_k_min, k = k, train = train)
  predict_new = cbind(predict, predictions)
  return(predict_new)
}


find_error = function(i, indices, distances, predict, train, k) {
  # given the fold and the indices, will determine the predict and train data for this fold
  # will then find the error of that particular fold
  
  indices_predict = indices[i]
  indices_train = indices[-i] # get rid of the fold we're not using
  indices_train = unlist(indices_train)
  
  predicted = knn_modified(predict, train, k, distances, indices_predict, indices_train)
  success = success_rate(predicted)
  return(success)
}


knn_cv = function(train, distances, m = 10, k = 4) {
  # train is the training data we want to use the to test the algorithm
  # m is how many folds we want in our m-fold cross validation
  # uses a given distance matrix
  
  rows_train = nrow(train)
  indices = c(1:rows_train)
  
  # create a list of indices of m folds; each fold has nrows / m
  list_indices = split(indices, rep(1:m, each = floor(rows_train / m), length.out = rows_train))
  
  predict = train # subsets of the same data set are used in cv; will subset these later
  
  # will get a list of errors for each fold
  errors = lapply(1:m, find_error, indices = list_indices, distances = distances,
                  predict = predict, train = train, k = k)
  errors = unlist(errors)
  mean_error = mean(errors)
  return(mean_error)
}
