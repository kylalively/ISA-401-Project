# Load the data
data <- read.delim('API data-mother age_state.txt', header = TRUE)

# Check the structure of the data
str(data)

# Remove the 1st, 3rd, 5th, and 7th columns
data[, c(1, 3, 5, 7, 9)] <- NULL

# Rename the third column
colnames(data)[3] <- "Mother's_age"

# Rename the third column
colnames(data)[4] <- "Metro/Non-Metro"

data <- data[-(11643:11671), ]

# To get a quick statistical summary of your data
summary(data)

# To view the first few rows of your data
head(data)


# Find the index of the minimum value in the "Births" column
min_index <- which.min(data$Births)

# Print the row of data with the minimum "Births" value
data[min_index, ]