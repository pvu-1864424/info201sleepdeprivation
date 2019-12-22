library(chron)
library(dplyr)
library(stringr)
library(ggplot2)
library(plotly)
library(usmap)

# Read in dataset
sleep_data <- read.csv("data/sleep_data.csv", stringsAsFactors = FALSE)
polysomnography_studies_df <- read.csv("data/polysomnography_studies.csv",
  stringsAsFactors = F
)
actigraphic_studies_df <- read.csv("data/actigraphic_studies.csv",
  stringsAsFactors = F
)
life_tracking_df <- read.csv("data/LifeTrackingProjectDataset.csv",
  stringsAsFactors = F
)
sleep_causes_df <- read.csv("data/SleepStudyData.csv", stringsAsFactors = F)
info_sleep_df <- read.csv("data/demdata_160225_pseudonymized.csv",
  stringsAsFactors = F
)
cause_factors_df <- read.csv("data/cause_factors.csv",
  stringsAsFactors = F
)
# this .csv file is too large to be uploaded on to Github
# US_df <- read.csv("data/500_Cities__Local_Data_for_Better_Health__2018_release.csv",
#                        stringsAsFactors = F)
# colnames(US_df)[1] <- "Year"
# this is the version after data wrangling for that huge .csv file
us_sleep_deprived <- read.csv("data/us_sleep_deprived.csv",
                              stringsAsFactors = F)
# read in dataset with US state and the lat and long
statelatlong <- read.csv("data/statelatlong.csv", stringsAsFactors = F)

# reform the dataframe by grouping the sleep time by years
colnames(polysomnography_studies_df)[1] <- "year"
polysomnography_grouped_df <- group_by(polysomnography_studies_df, year) %>%
  summarize(sleep_time = mean(sleep_time)) %>%
  mutate(type = "Polysomnography Study")
colnames(actigraphic_studies_df)[1] <- "year"
actigraphic_grouped_df <- group_by(actigraphic_studies_df, year) %>%
  summarize(sleep_time = mean(sleep_time)) %>%
  mutate(type = "Actigraphic Study")

# create a point plot and a best fit line with color difference to emphasize
# the data from two different study
draw_sleep_trend_plot <- function(number) {
  if (number == 1) {
    grouped_df <- actigraphic_grouped_df
  } else if (number == 2) {
    grouped_df <- polysomnography_grouped_df
  } else {
    grouped_df <- bind_rows(polysomnography_grouped_df,
                            actigraphic_grouped_df) %>%
      arrange(year)
  }
  ggplot(data = grouped_df) +
    geom_point(mapping = aes(x = year, y = sleep_time, color = type)) +
    geom_smooth(mapping = aes(x = year, y = sleep_time)) +
    ggtitle("US adults sleeping times for the recent decades") +
    scale_x_continuous(name = "Year") +
    scale_y_continuous(name = "Sleep Time (minute)") +
    labs(color = "Studies' Methods: ")
}

# data wrangling into data columns that needed in the map
# us_sleep_deprived <- US_df %>%
#   filter(MeasureId == "SLEEP") %>%
#   select(Year, StateAbbr, CityName, Data_Value, PopulationCount, GeoLocation, Short_Question_Text)
# write.csv(us_sleep_deprived, file = "us_sleep_deprived.csv")

# data wrangling with dataset,
new_df <- group_by(us_sleep_deprived, StateAbbr) %>%
  filter(StateAbbr != "US") %>%
  summarize(
    ave_percent = sum(Data_Value, na.rm = T) / n(),
    population = sum(PopulationCount)
  ) %>%
  mutate(statelatlong$Latitude, statelatlong$Longitude)
colnames(new_df) <- c("state", "percent", "population", "lat", "long")

# plot the US map with data info
# version 1.0 without hover interaction ---- succeed
draw_us_sleep_map <- function() {
  plot_usmap(
    data = new_df, values = "percent", color = "white", labels = T,
    label_color = "white"
  ) +
    scale_fill_continuous(
      low = "lightgrey", high = "black",
      name = "Sleep <7 hours(%)",
      label = scales::comma
    ) +
    theme(legend.position = "right")
}

# version 1.1 with hover interaction --- failed
ggplotly(plot_usmap(
  data = new_df, values = "percent", color = "white", labels = T,
  label_color = "white"
) +
  scale_fill_continuous(
    low = "lightgrey", high = "black",
    name = "Sleep <7 hours(%)",
    label = scales::comma
  ) +
  theme(legend.position = "right"),
tooltip = c("value")
)

# bar graph of GPA and feeling-tired relationship
draw_bar_graph_gpa_tired <- function() {
  plot_ly(
    x = c("Yes", "No"),
    y = c(3.04, 3.24),
    type = "bar"
  ) %>%
    layout(
      title = "Feeling tired, fatigued, or daytime sleepiness",
      xaxis = list(title = "Answer"),
      yaxis = list(title = "GPA", range = c(3.0, 3.3))
    ) %>%
    return()
}

# draw brutal reality visualization 1
draw_br1 <- function() {
  plot_ly(
    x = c("Yes", "No"),
    y = c(3.04, 3.24),
    type = "bar"
  ) %>%
    layout(
      Title = "Gender",
      xaxis = list(title = "Gender"),
      yaxis = list(title = "SicknessQ", range = c(3.0, 3.3))
    ) %>%
    return()
}
# draw brutal reality visualization 2
draw_br2 <- function() {
  plot_ly(
    x = c("Yes", "No"),
    y = c(3.04, 3.24),
    type = "bar"
  ) %>%
    layout(
      Title = "Gender",
      xaxis = list(title = "Enough"),
      yaxis = list(title = "Tired", range = c(3.0, 3.3))
    ) %>%
    return()
}

# add a coloumn of total 'activity' time in minute
convert_to_min <- function(activity) {
  activity_time <- life_tracking_df %>%
    mutate(activity = paste0(!!as.name(activity), ":00")) %>%
    pull(activity)
  activity_format <- times(activity_time)
  activity_hour <- hours(activity_format)
  activity_minute <- minutes(activity_format)
  total_activity_min <- 60 * activity_hour + activity_minute
  life_tracking_df <- life_tracking_df %>%
    mutate("new_col" = total_activity_min)
}

# add a column of total sleep time in minute
life_tracking_df <- convert_to_min("sleep") %>%
  rename(sleep_time = new_col)

# test test
compare_table <- convert_to_min("cook") %>%
  select(sleep_time, new_col)
colnames(compare_table) <- c("sleep-time", "cook")
ggplot(compare_table,
    aes(x = cook, y = !!as.name("sleep-time"))) + geom_point() + geom_smooth()

# a function for bar graph of given sleep time and input time
draw_compare_line <- function(other) {
  compare_table <- convert_to_min(other) %>%
    select(sleep_time, new_col)
  colnames(compare_table) <- c("sleep_time", other)
  ggplot(compare_table, aes(x = !!as.name(other),
                            y = !!as.name("sleep_time"))) +
    geom_point() +
    geom_smooth()
}

# impacts for sleep deprivation
new_sleep_info <- info_sleep_df %>%
  select(AgeGroup, HADS_Anxiety, HADS_Depression, KSQ_Panic, KSQ_Worry,
         KSQ_HealthProblem)
new_sleep_info <- new_sleep_info[-13, ]
colnames(new_sleep_info) <- c("age", "anxiety", "depression",
                              "panic", "worry", "health")
new_sleep_info$panic <- as.numeric(substring(new_sleep_info$panic, 1, 2))
new_sleep_info$worry <- as.numeric(substring(new_sleep_info$worry, 1, 2))
new_sleep_info$health <- as.numeric(substring(new_sleep_info$health, 1, 2))

# test
df <- new_sleep_info[new_sleep_info$age == "Young", ]
df$user <- 1:nrow(df)
result <- df %>%
  select(anxiety, user)
ggplot(result, aes(x = user, y = anxiety, color = anxiety)) + geom_point() +
  geom_hline(aes(yintercept = mean(anxiety), color = anxiety))

# plot scatterplot for impacts
plot_impacts <- function(age.group, symptoms) {
  df <- new_sleep_info[new_sleep_info$age == age.group, ]
  df$user <- 1:nrow(df)
  result <- df %>%
    select(symptoms, user)
  ggplot(result, aes(x = user, y = !!as.name(symptoms),
                     color = !!as.name(symptoms))) + geom_point() +
    geom_hline(aes(yintercept = mean(!!as.name(symptoms)),
                   color = !!as.name(symptoms)))
}

# draw pie chart for cause factors
draw_pie <- function() {
  p <- plot_ly(cause_factors_df, labels = ~Factor, values = ~Percentage,
               type = "pie") %>%
    layout(
      title = "University Students' self-reported causes of sleep
      deprivation by factors",
      xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
      yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE)
    )
  return(p)
}

calculate_sleep <- function(age, wake_up) {
  if (age == 1) {
    amount <- 12
  } else if (age <= 2) {
    amount <- 11
  } else if (age <= 5) {
    amount <- 10
  } else if (age <= 12) {
    amount <- 9
  } else if (age <= 18) {
    amount <- 8
  } else {
    amount <- 7
  }
  suppose_sleep <- wake_up - amount
  if (suppose_sleep < 0) {
    suppose_sleep <- 24 + suppose_sleep
  }
  statement <- paste0("Your bed time should be before ", suppose_sleep, ":00")
  return(statement)
}

age_statement <- function(age) {
  statement <- paste0("You are ", age, " years old!")
}

wake_statement <- function(time) {
  statement <- paste0("If you need to wake up at ", time, ":00, then:")
}
