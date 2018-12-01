library(purrr)
library(dplyr)
library(ggplot2)

data <- read.csv("repdata-data-StormData.csv", stringsAsFactors = FALSE)
glimpse(data)

#FATALITIES; INJURIES; PROPDMG; CROPDMG

fatalities <- data %>% select(EVTYPE, FATALITIES) %>% group_by(EVTYPE) %>%
  summarize(total_fatalities = sum(FATALITIES)) %>% 
  arrange(desc(total_fatalities)) %>% top_n(10)
#FATALITIES; INJURIES; PROPDMG; CROPDMG

fatalities_graph <- ggplot(data=fatalities, 
                           aes(x=reorder(EVTYPE, -total_fatalities), 
                           y=total_fatalities)) +
                    geom_bar(stat="identity", fill="lightblue")+
                    geom_text(aes(label=total_fatalities), vjust=-0.9, color="gray43", size=3.5)+
                    ggtitle("Top 10 harmful events (fatalities)", 
                            subtitle = "The most harmful type of events across the U.S with respect to population health.") +
                    xlab("") + 
                    ylab("Fatalities") +
                    ylim(0, 6500) +
                    theme_minimal() + 
                    theme(axis.text.x = element_text(angle = 90, hjust = 0.5), 
                          panel.border = element_blank(),
                          panel.background = element_blank(),
                          axis.line = element_line(colour = "black"),
                          panel.grid.minor = element_blank(),
                          panel.grid.major = element_blank()
                    )
fatalities_graph                    


injuries <- data %>% select(EVTYPE, INJURIES) %>% group_by(EVTYPE) %>%
  summarize(total_injuries = sum(INJURIES)) %>% 
  arrange(desc(total_injuries)) %>% top_n(10)

injuries_graph <- ggplot(data=injuries, 
                         aes(x=reorder(EVTYPE, -total_injuries), 
                         y=total_injuries)) +
                  geom_bar(stat="identity", fill="tomato2")+
                  geom_text(aes(label=total_injuries), vjust=-0.9, color="gray43", size=3.5)+
                  ggtitle("Top 10 harmful events (injuries)", 
                          subtitle = "The most harmful type of events across the U.S with respect to population health.") +
                  xlab("") + 
                  ylab("Injuries") +
                  ylim(0, 100000) +
                  theme_minimal() + 
                  theme(axis.text.x = element_text(angle = 90, hjust = 0.5), 
                        panel.border = element_blank(),
                        panel.background = element_blank(),
                        axis.line = element_line(colour = "black"),
                        panel.grid.minor = element_blank(),
                        panel.grid.major = element_blank()
                   )
injuries_graph

#Exponent function
exponentials <- function(abreviation) {
  abreviation <- as.character(abreviation)
  hundred <- c("h", "H")
  thousand <- c("k", "K")
  million <- c("m", "M")
  billion <- c("b", "B")
  value <- 0
  if (abreviation %in% hundred) {
    value <- 100
  } else if (abreviation %in% thousand) {
    value <- 1000
  } else if (abreviation %in% million) {
    value <- 1000000
  } else if (abreviation %in% billion) {
    value <- 1000000000
  } else {
    value <- 0
  }
  value
}


property <- data %>% select(EVTYPE, PROPDMG, PROPDMGEXP) %>%
    mutate(exponent = map_dbl(as.character(PROPDMGEXP), exponentials))
property <- property %>% mutate(value = (PROPDMG * exponent)/1000000) %>% select(EVTYPE, value) %>%
            group_by(EVTYPE) %>%
            summarize(property_damage = sum(value)) %>% 
            arrange(desc(property_damage)) %>% top_n(10)


property_graph <- ggplot(data=property, 
                         aes(x=reorder(EVTYPE, -property_damage), 
                         y=property_damage)) +
                  geom_bar(stat="identity", fill="brown3")+
                  geom_text(aes(label=round(property_damage, 2)), vjust=-0.9, color="gray43", size=3)+
                  ggtitle("Top 10 harmful events (property damage)", 
                          subtitle = "The most economic harmful type of events across the U.S.") +
                  xlab("") + 
                  ylab("Property damage (millions) ") +
                  ylim(0, 150000) +
                  theme_minimal() + 
                  theme(axis.text.x = element_text(angle = 90, hjust = 0.5), 
                        panel.border = element_blank(),
                        panel.background = element_blank(),
                        axis.line = element_line(colour = "black"),
                        panel.grid.minor = element_blank(),
                        panel.grid.major = element_blank()
                  )

property_graph                    



crop <- data %>% select(EVTYPE, CROPDMG, CROPDMGEXP) %>%
  mutate(exponent = map_dbl(as.character(CROPDMGEXP), exponentials))
crop <- crop %>% mutate(value = (CROPDMG * exponent)/1000000) %>% select(EVTYPE, value) %>%
  group_by(EVTYPE) %>%
  summarize(crop_damage = sum(value)) %>% 
  arrange(desc(crop_damage)) %>% top_n(10)


crop_graph <- ggplot(data=crop, 
                         aes(x=reorder(EVTYPE, -crop_damage), 
                             y=crop_damage)) +
  geom_bar(stat="identity", fill="springgreen3")+
  geom_text(aes(label=round(crop_damage, 2)), vjust=-0.9, color="gray43", size=3)+
  ggtitle("Top 10 harmful events (crop damage)", 
          subtitle = "The most economic harmful type of events across the U.S.") +
  xlab("") + 
  ylab("Crop damage (millions) ") +
  ylim(0, 15000) +
  theme_minimal() + 
  theme(axis.text.x = element_text(angle = 90, hjust = 0.5), 
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(colour = "black"),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_blank()
  )

crop_graph                    

