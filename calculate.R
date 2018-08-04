source("functions/functions.R")

library(lubridate) # install.packages(c("lubridate", "ggplot2", "scales", "reshape2"))
library(ggplot2)
library(reshape2)
library(scales)

# Inputs. -----------------------------------------------------------------
event <- "OH"
results_dir <- "/path/to/directory/"
save_results <- FALSE

# Extract times. ----------------------------------------------------------
times_raw <- "27.71, 29.10, 34.38, 26.33, 25.00, 28.82, 24.57, 29.18, 26.46, 33.56, 35.19, 23.93, 22.68, 22.11, 30.56, 27.28, 26.42, 24.22, 23.83, 30.56, 26.03, 26.00, 26.95, 24.39, 28.79, 33.32, 23.27, 26.60, 28.54, 18.98, 26.97, 24.99, 27.93, 30.07, 27.46, 24.15, 25.60, 26.85, 30.24, 25.46, 25.72, 29.00, 27.51, 25.42, 32.38, 31.68, 26.51, 24.70, 30.95, 32.41, 29.90, 21.47, 21.52, 24.42, 32.55, 34.54, 28.50, 32.77, 30.36, 25.57, 25.20, 23.45, 30.47, 19.77, 19.16, 19.68, 21.85, 25.58, 20.55, 28.34, 21.11, 24.57, 22.21, 24.42, 23.65, 29.97, 29.96, 22.93, 25.83, 19.86, 24.38, 25.94, 31.12, 34.43, 31.25, 24.04, 23.19, 27.58, 30.66, 27.33, 32.56, 29.87, 22.84, 35.33, 22.86, 25.41, 26.15, 25.77, 28.26, 25.63"
times_split <- trimws(strsplit(times_raw, ",")[[1]])
times <- unname(sapply(times_split, fn_convert_time))

# Create a table. ---------------------------------------------------------
len = length(times)

df <- data.frame(
  id = 1:len,
  session_part = fn_calculate_session_parts(len),
  times = times,
  times_rounded_floor = floor(times),
  times_rounded_full = round(times),
  times_rounded_one_digit = round(times, 1)
)

# Do some analyses. -------------------------------------------------------
df$ao5 <- fn_moving_average(df$times, 5)
df$ao12 <- fn_moving_average(df$times, 12)
df$ao25 <- fn_moving_average(df$times, 25)

View(df)
summary(df)

# Basic plots -------------------------------------------------------------
value_counts <- data.frame(table(df$times_rounded_floor, df$session_part))
value_counts_basic <- data.frame(table(df$times_rounded_floor))

# main bar template
qq_labs <- labs(x="Seconds taken", 
                y="Number of solves", 
                fill = "Session part")
qq_theme <- scale_color_brewer(palette="Dark2")
qq_title <-ggtitle(sprintf("%s breakdown", event))

# stacked
ggplot(data=value_counts_basic, aes(x=Var1, y=Freq)) +
  qq_title + 
  qq_labs +
  qq_theme + geom_bar(stat="identity")

# faceted
flt = value_counts[value_counts$Freq > 0,]
flt$Var2 = ifelse(flt$Var2 == 1, "1-25", 
                  ifelse(flt$Var2 == 2, "26-50",
                         ifelse(flt$Var2 == 3, "51-75", "76-100")))
  
ggplot(data=flt, aes(x=Var1, y=Freq, fill=Var2)) +
  qq_title + 
  qq_labs +
  qq_theme + 
  geom_bar(stat="identity") +
  facet_wrap(~Var2)

# side-by-side
# g + geom_bar(stat="identity", position=position_dodge())

# main line templates
mlt <- setNames(melt(df[c(1,7:9)], id="id"), c("Solve", "Average", "Seconds"))
mlt <- mlt[!is.na(mlt$Seconds),]

ggplot(mlt, aes(x=Solve, y=Seconds, group=Average, color=Average)) + 
  geom_line() +
  qq_title +
  scale_x_continuous(breaks=pretty_breaks(n=10)) + 
  scale_y_continuous(breaks=pretty_breaks(n=10)) +
  xlab("Solve number") +
  ylab("Time (seconds)")
  

# Write the results. ------------------------------------------------------
if(save_results){
  today <- substr(Sys.time(), 1, 10)
  output_file <- paste0(results_dir, event, "_", gsub("-", "", today), "_practice.csv")
  write.csv(df, output_file, row.names = F, quote = F)  
}



