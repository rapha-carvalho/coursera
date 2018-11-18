library(dplyr)
SUMMARY <- readRDS("summarySCC_PM25.rds")

plot2_tbl <- SUMMARY %>% subset(fips == "24510") %>%
                    select(year, Emissions)
glimpse(plot2_tbl)

plot2_tbl <-plot2_tbl %>% group_by(year) %>% 
  summarize(Sum.Emissions = sum(Emissions, na.rm = TRUE))


plot2 <- with(plot2_tbl, 
              barplot(height = Sum.Emissions, 
                      names.arg = year,
                      xlab = "Year",
                      ylab = "Total emissions (ton)", 
                      col = "light blue",
                      main = "Total sum of Emissions in Baltimore per year"
              )
)

dev.copy(png, file = "final_plot2.png", width=480, height=480)
dev.off()
