library(readr)
library(dplyr)

url <- "https://raw.githubusercontent.com/japhet125/global-baseline-assign/refs/heads/main/u.data"

ratings <- read_delim(
  url,
  delim = "\t",
  col_names = c("userId", "movieId", "rating", "timestamp")
  
)
ratings <- ratings[, c("userId", "movieId", "rating")]
head(ratings)