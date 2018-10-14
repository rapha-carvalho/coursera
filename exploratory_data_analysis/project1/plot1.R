library(dplyr)
library(lubridate)
home_dw <- "/Users/raphael/"
course_dw <- "coursera-repo/coursera/exploratory_data_analysis/project1/"
file_name <- "household_power_consumption.txt"
file_dw <- paste(home_dw, course_dw, file_name, sep = "")

data <- read.table(file_dw, sep = ";", header = TRUE,  dec = ".", stringsAsFactors = FALSE)

data <- data %>% mutate(
  Date = dmy(Date), 
  Global_active_power = as.numeric(Global_active_power),
  Global_reactive_power = as.numeric(Global_reactive_power),
  Voltage = as.numeric(Voltage),
  Global_intensity = as.numeric(Global_intensity),
  Sub_metering_1 = as.numeric(Sub_metering_1),
  Sub_metering_2 = as.numeric(Sub_metering_2),
  Sub_metering_3 = as.numeric(Sub_metering_3)
) %>% filter(Date >= dmy("01/02/2007"), Date <= dmy("02/02/2007"))

#glimpse(data)

hist(data$Global_active_power, col="red", main="Global Active Power", 
     xlab="Global Active Power (kilowatts)")
dev.copy(png, file = "plot1.png", width=480, height=480)
dev.off()