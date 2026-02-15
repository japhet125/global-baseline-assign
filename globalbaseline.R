library(readr)
library(dplyr)


#loading the data from my github
url <- "https://raw.githubusercontent.com/japhet125/global-baseline-assign/refs/heads/main/u.data"

#data 
ratings <- read_delim(
  url,
  delim = "\t",
  col_names = c("userId", "movieId", "rating", "timestamp")
  
)
ratings <- ratings[, c("userId", "movieId", "rating")]
head(ratings)

#calculating the global average from all rating

gm <- mean(ratings$rating, na.rm = TRUE)
gm

#calculating the users bias
users_bias <- ratings %>%
  group_by(userId) %>%
summarise(
  user_avg = mean(rating),
  u_b = user_avg - gm
  
)
users_bias

#calculate the movie bias, we will use avg movie rating - glabal avg rating

movies_bias <- ratings %>%
  group_by(movieId) %>%
  summarise(
    movie_avg = mean(rating),
    m_b = movie_avg - gm
  )
movies_bias

#merging bias back to data to predict the rating

ratings_pred <- ratings %>%
  left_join(users_bias, by = "userId") %>%
  left_join(movies_bias, by = "movieId") %>%
  
  mutate(
    predicted_rating = gm + u_b + m_b
  )

ratings_pred
  
# making movie recommendation to user

all_movies <- unique(ratings$movieId)

user_id <- 1

rated_movies <- ratings %>%
  filter(userId == user_id) %>%
  pull(movieId)

unrated_movies <- setdiff(all_movies, rated_movies)

unrated_movies

#predicting ratings for those movies

recommendation <- movies_bias %>%
  filter(movieId %in% unrated_movies) %>%
  left_join(users_bias %>% filter(userId == user_id), by = character()) %>%
  mutate(
    predicted_rating = gm + u_b + m_b
  ) %>%
  arrange(desc(predicted_rating))

head(recommendation, 5)
