library(dplyr)
library(ggplot2)
SUMMARY <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

vehicle <- SCC[grep("[Vv]eh", SCC$Short.Name), ]

emissions.motor.baltimore <- SUMMARY %>% 
  subset(fips == "24510" & SUMMARY$SCC %in% vehicle$SCC) %>%
  merge(y = vehicle, by.x = "SCC", by.y = "SCC") %>%
  group_by(year) %>%
  summarize(Sum.Emissions = sum(Emissions, na.rm = TRUE)) %>%
  mutate(city = "Baltimore")


emissions.motor.la <- SUMMARY %>% 
  subset(fips == "06037" & SUMMARY$SCC %in% vehicle$SCC) %>%
  merge(y = vehicle, by.x = "SCC", by.y = "SCC") %>%
  group_by(year) %>%
  summarize(Sum.Emissions = sum(Emissions, na.rm = TRUE)) %>%
  mutate(city = "LA")


emissions.comp <- rbind(emissions.motor.baltimore, emissions.motor.la)

plot6 <- ggplot(emissions.comp, aes(year, Sum.Emissions)) +
  facet_grid(.~city) +
  geom_bar(stat = "identity") +
  xlab("Year") +
  ylab("Total Emissions (Ton)") +
  ggtitle("Comparison of Total Annual Vehicle Emissions in Baltimore and Los Angeles")
 
plot6

dev.copy(png, file = "plot6.png", width=800, height=600)
dev.off()
