# viewing 16x16 images
# by Nathan Chan
# github.com/nathanjchan
# nathanjchan2@gmail.com


# functions to view the 16x16 images
# each image in the text file is represented by 256 pixel values, -1 to 1
# -1 means pure white and 1 means pure black


source("knn.R")


display_image = function(numbers) {
  # takes in a string of 256 numbers and presents the 16x16 image
  number_image = split_numbers(numbers)
  number_image = matrix(number_image, nrow = 16, ncol = 16, byrow = TRUE)
  number_image = apply(number_image, 2, rev)
  number_image = t(number_image)
  image(number_image, col = grey(seq(0, 1, length = 256)))
}


average_image = function(number, df) {
  # given a number 0-9, and the data frame, will return what the average number looks like
  # basically taking the average of all the pixel values
  df2 = subset(df, df[, 1] == number)
  avg_image = matrix(0, nrow = 16, ncol = 16, byrow = TRUE)
  
  # avg_image is an empty matrix
  # add all items from df2 into avg_image
  for (i in seq_along(df2)) {
    numbers = df2[i, 2]
    avg_image2 = split_numbers(numbers)
    avg_image2 = matrix(avg_image2, nrow = 16, ncol = 16, byrow = TRUE)
    avg_image = avg_image + avg_image2
  }
  
  # divide avg_image to get the average matrix
  num_row = nrow(df2)
  avg_image = avg_image / num_row
  avg_image = apply(avg_image, 2, rev)
  avg_image = t(avg_image)
  image(avg_image, col = grey(seq(0, 1, length = 256)))
}


digits_test = read_digits("test.txt")
digits_train = read_digits("train.txt")
digits = rbind(digits_test, digits_train)

# always give display_image() column 2 of the data frame
# because that is where the 256 pixel values are stored
# example - displaying image 600:
display_image(digits[600, 2])

# average images:
average_image(0, digits)
average_image(1, digits)
average_image(2, digits)
average_image(3, digits)
average_image(4, digits)
average_image(5, digits)
average_image(6, digits)
average_image(7, digits)
average_image(8, digits)
average_image(9, digits)
