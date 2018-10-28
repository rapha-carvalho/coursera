library(dplyr)
library(ggplot2)
SUMMARY <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

vehicle <- SCC[grep("[Vv]eh", SCC$Short.Name), ]

emissions.motor.baltimore <- SUMMARY %>% 
  subset(fips == "24510" & SUMMARY$SCC %in% vehicle$SCC) %>%
  merge(y = vehicle, by.x = "SCC", by.y = "SCC") %>%
  group_by(year) %>%
  summarize(Sum.Emissions = sum(Emissions, na.rm = TRUE))


plot5 <- ggplot(emissions.motor.baltimore, aes(year, Sum.Emissions)) +
  geom_bar(color = "grey", 
             stat = 'identity') + 
  xlab("Year") +
  ylab("Total Emissions (ton)") +
  ggtitle("Total Annual Vehicle Emissions in Baltimore City")

plot5

dev.copy(png, file = "plot5.png", width=480, height=480)
dev.off()
