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
times_raw <- "5.99, 5.28, 5.25, 6.13, 9.19"
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



