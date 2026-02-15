library(dplyr)
library(lubridate)
library(tidyr)

#install.packages("zoo")
library(zoo)

set.seed(123)
dates <- seq.Date(from = as.Date("2022-01-01"), 
                  to = as.Date("2022-12-31"), by = "day")
crypto <- c("Bitcoin", "Ethereum")
data <- expand.grid(date = dates, crypto = crypto)

# Simulate daily closing prices
data$price <- round(runif(nrow(data), 1000, 50000), 2)

# Preview dataset
head(data)

#calculating window functions

data_analysis <- data %>%
  arrange(crypto, date) %>%
  group_by(crypto) %>%
  
  mutate(ytd_avg = cummean(price)) %>%
  
  mutate( ma_6day = zoo::rollmean(price, k = 6, fill = NA, align = "right")) %>%
  ungroup()
  

head(data_analysis, 10)  


