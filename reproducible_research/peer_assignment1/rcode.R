# Code for the assignment
library(dplyr)
home <- getwd()
filename <- "activity.csv"
data <- read.csv(paste0(home, "/", filename), stringsAsFactors = FALSE)
data$date<-as.Date(data$date)
glimpse(data)

grouped_steps <- data %>% group_by(date) %>% summarise(num_steps = sum(steps, na.rm = TRUE))

#First plot
hist(grouped_steps$num_steps, 
     breaks=seq(from=0, to=25000, by=2500),
     col="light blue", 
     xlab="Number of steps", 
     ylim=c(0, 20), 
     main="Number of steps taken each day\n(NA removed)")


dev.copy(png, file = "figures/hist1_na_removed.png", width=800, height=600)
dev.off()


#Median 
median_na_rm <- round(summary(grouped_steps$num_steps)[[3]])
#Mean
mean_na_rm <- round(summary(grouped_steps$num_steps)[[4]],2)


grouped_avg_steps<-data %>% group_by(interval) %>% summarise(avg_steps = mean(steps,na.rm = TRUE))

library(ggplot2)

g <- ggplot(aes(x=interval,y=avg_steps),data=grouped_avg_steps)+geom_line(aes(color = 'light red'), show.legend = FALSE) 
g <- g + theme_minimal()
g <- g + ggtitle("Average steps per 5 minute interval per day") 
g <- g + labs(x = "5 minute interval", y = "Average steps")
print(g)

dev.copy(png, file = "figures/line1_na_removed.png", width=800, height=600)
dev.off()


#The 5-minute interval that, on average, contains the maximum number of steps
max_steps <- grouped_avg_steps[[which.max(grouped_avg_steps$avg_steps), 1]]

#Calculating the number of NA values 
sum(is.na(data$steps))


#Filling NA strategy 
new_data <- data
new_data$steps[is.na(new_data$steps)] <- as.integer(mean(new_data$steps,na.rm=TRUE))
glimpse(new_data)

new_grouped_steps <- new_data %>% group_by(date) %>% summarise(num_steps = sum(steps, na.rm = TRUE))

#First plot with NA's filled
hist(new_grouped_steps$num_steps, 
     breaks=seq(from=0, to=25000, by=2500),
     col="light blue", 
     xlab="Number of steps", 
     ylim=c(0, 30), 
     main="Number of steps taken each day\n(NA filled)")

dev.copy(png, file = "figures/hist2_na_filled.png", width=800, height=600)
dev.off()


#Median 
new_median <- round(summary(new_grouped_steps$num_steps)[[3]], 2)
#Mean
new_mean <- round(summary(new_grouped_steps$num_steps)[[4]], 2)


new_data$days <-tolower(weekdays(data$date))
new_data$day_type <- ifelse(new_data$days == "saturday" | new_data$days == "sunday","weekend","weekday")
glimpse(new_data)

table(new_grouped_avg_steps$day_type)

new_grouped_avg_steps <- new_data %>% group_by(interval, day_type) %>% summarise(avg_steps = mean(steps,na.rm = TRUE))



# Create panel plot between average steps and interval seperated by day type

gline <- ggplot(aes(x=interval,y=avg_steps),data=new_grouped_avg_steps)+geom_line(aes(color = 'light red'))
gline <-  gline + facet_wrap(~new_grouped_avg_steps$day_type) + theme_minimal()
gline <- gline + ggtitle("Average steps per 5 minute interval per day (weekday x weekend)")
gline <- gline + labs(x = "5 minute interval", y = "Average steps")
print(gline)

dev.copy(png, file = "figures/line2_na_filled.png", width=800, height=600)
dev.off()
