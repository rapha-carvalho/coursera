library(dplyr)
library(ggplot2)
SUMMARY <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

SCC.coal <- SCC[grep("[Cc]oal",SCC$EI.Sector),]
glimpse(SCC.coal)
SUMMARY.coal <- subset(SUMMARY, 
                       SUMMARY$SCC %in% SCC.coal$SCC)

glimpse(SUMMARY.coal)
SUMMARY.merge <- merge(x = SUMMARY.coal, 
                       y = SCC, 
                       by.x = "SCC", 
                       by.y = "SCC")
glimpse(SUMMARY.merge)

SUMMARY.total <- SUMMARY.merge %>% 
  group_by(year) %>%
  summarize(total.coal = sum(Emissions, na.rm = TRUE))

plot4 <- ggplot(SUMMARY.total, aes(year, total.coal))

plot4 <- plot4 + 
  geom_bar(color = "grey", 
            stat = 'identity') + 
  xlab("Year") +
  ylab("Total Emissions [Tons]") +
  ggtitle(" Total Annual Coal Combustion Emissions in the US")

plot4

dev.copy(png, file = "plot4.png", width=480, height=480)
dev.off()

