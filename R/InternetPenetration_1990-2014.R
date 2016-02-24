load("data/WorldMap-InternetPenetration.Rda")
library(ggplot2)
library(maps)
library(ggmap)
library(extrafont)

# Spot check country and year
mean_check <- function(x, y) {
  z <- mean(WorldMapInternetPenetration[WorldMapInternetPenetration["region"] == x, as.character(y)])
  return(z)
}


# Loop through all years and store image in list
a <- lapply(1990:2014, ggplot_intpen, data = WorldMapInternetPenetration)
