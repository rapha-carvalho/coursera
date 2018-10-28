library(dplyr)
SUMMARY <- readRDS("summarySCC_PM25.rds")

plot1_tbl <- select(SUMMARY, year, Emissions)
glimpse(plot1_tbl)

plot1_tbl <-plot1_tbl %>% group_by(year) %>% 
             summarize(Sum.Emissions = sum(Emissions, na.rm = TRUE))


plot1 <- with(plot1_tbl, 
             barplot(height = Sum.Emissions, 
                    names.arg = year,
                    xlab = "Year",
                    ylab = "Total emissions (ton)", 
                    col = "light blue",
                    main = "Total sum of Emissions in US per year"
                    )
              )

dev.copy(png, file = "plot1.png", width=480, height=480)
dev.off()
