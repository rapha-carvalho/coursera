library(dplyr)
library(lubridate)
home_dw <- "/Users/raphael/"
course_dw <- "coursera-repo/coursera/exploratory_data_analysis/project1/"
file_name <- "household_power_consumption.txt"
file_dw <- paste(home_dw, course_dw, file_name, sep = "")

data <- read.table(file_dw, sep = ";", header = TRUE,  dec = ".", stringsAsFactors = FALSE)

data <- data %>% mutate(
  Date = dmy(Date),
  date_time = ymd_hms(paste(Date, Time, sep=" ")),
  Global_active_power = as.numeric(Global_active_power),
  Global_reactive_power = as.numeric(Global_reactive_power),
  Voltage = as.numeric(Voltage),
  Global_intensity = as.numeric(Global_intensity),
  Sub_metering_1 = as.numeric(Sub_metering_1),
  Sub_metering_2 = as.numeric(Sub_metering_2),
  Sub_metering_3 = as.numeric(Sub_metering_3)
) %>% filter(Date >= dmy("01/02/2007"), Date <= dmy("02/02/2007"))



par(mfrow = c(2, 2)) 

plot(data$date_time, data$Global_active_power, type="l", xlab="", ylab="Global Active Power", cex=0.2)

plot(data$date_time, data$Voltage, type="l", xlab="datetime", ylab="Voltage")

plot(data$date_time, data$Sub_metering_1, type="l", ylab="Energy sub metering", xlab="")
lines(data$date_time, data$Sub_metering_2, type="l", col="red")
lines(data$date_time, data$Sub_metering_3, type="l", col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=, lwd=2.5, col=c("black", "red", "blue"), bty="n")

plot(data$date_time, data$Global_reactive_power, type="l", xlab="datetime", ylab="Global reactive power")

dev.copy(png, file = "plot4.png", width=480, height=480)
dev.off()