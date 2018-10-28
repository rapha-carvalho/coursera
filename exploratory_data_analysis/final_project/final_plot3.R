library(dplyr)
library(ggplot2)
SUMMARY <- readRDS("summarySCC_PM25.rds")

plot3_tbl <- SUMMARY %>% subset(fips == "24510") %>%
  select(year, type, Emissions)

glimpse(plot3_tbl)

plot3_tbl <-plot3_tbl %>% group_by(year, type) %>% 
  summarize(Sum.Emissions = sum(Emissions, na.rm = TRUE))

emissions.type <- ggplot(data = plot3_tbl, aes(year, Sum.Emissions)) +
  facet_grid(.~type) + geom_bar(stat='identity')



dev.copy(png, file = "plot3.png", width=800, height=600)
dev.off()
  