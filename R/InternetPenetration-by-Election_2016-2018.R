load("data/onlineVoters.rda")

black2green <- colorRampPalette(c("black", "green"))(7)
white2blue <- brewer.pal(7, name = "Blues"))

# All Elections, only 2014 Internet Penetration Rate subset
intPen2014 <- onlineVoters[, c("Country", "Election for", "Date", "ElectionYear", "2014")]
names(intPen2014)[5] <- "intPen"
intPen2014$intPen <- intPen2014$intPen/100

# 2016 Elections subset
elections2016 <- subset(onlineVoters, ElectionYear == 2016)
elections2016 <- elections2016[order(elections2016$`2014`, decreasing = TRUE), ]
elections2016 <- elections2016[order(elections2016$Date, decreasing = FALSE), ]
topElections2016 <- elections2016[, c("Country", "Election for", "Date", "2014")]
# topElections2016 <- subset(topElections2016, `2014` > 50)


elections2017 <- subset(onlineVoters, ElectionYear == 2017)
elections2017 <- elections2017[order(elections2017$`2014`, decreasing = TRUE), ]
elections2017 <- elections2017[order(elections2017$Date, decreasing = FALSE), ]
topElections2017 <- elections2017[, c("Country", "Election for", "Date", "2014")]
# topElections2017 <- subset(topElections2017, `2014` > 50)




# Graph: rworldmap --------------------------------------------------------

library(rworldmap)
map.elections2016 <- joinCountryData2Map(topElections2016, joinCode = "NAME", nameJoinColumn = "Country")
a <- mapCountryData(map.elections2016,
                    nameColumnToPlot = "2014",
                    mapTitle = "Internet Penetration in 2016 Elections",
                    colourPalette = black2green)
map.elections2017 <- joinCountryData2Map(topElections2017, joinCode = "NAME", nameJoinColumn = "Country")
mapCountryData(map.elections2017,
               nameColumnToPlot = "2014",
               mapTitle = "Internet Penetration in 2017 Elections",
               colourPalette = black2green)


# Graph: ggplot2 and maps--------------------------------------------------

library(ggplot2)
library(maps)

# Generate Blank World Map
world <- map_data("world")
p <- ggplot() + geom_polygon(data=world, aes(x=long, y=lat, group = group),
                             colour = "white", fill = "grey10")

# Create new map to overlay, order by $order to prevent fill overspill

a <- as.character(unique(intPen2014$Country))
b <- unique(world$region)
len <- length(b) - length(a)
a <- c(a, rep(NA, len))
c <- match(a, b)
d <- cbind(a, b)


# Export for manual matching
# write.csv(d, file = "data/nameMatching.csv", row.names = F)
# Import post edit
nameIndex <- read.csv("data/nameMatching.csv")
nameChange <- nameIndex[which(!nameIndex[, "IntPen"] %in% nameIndex[, "world"]), ]

levels(intPen2014[, "Country"])[levels(intPen2014[, "Country"]) == "Gambia, The"] <- "Gambia"
levels(intPen2014[, "Country"])[levels(intPen2014[, "Country"]) == "United States"] <- "USA"
levels(intPen2014[, "Country"])[levels(intPen2014[, "Country"]) == "United Kingdom"] <- "USA"

worldOnlineVoters <- merge(world, intPen2014, by.x = "region", by.y = "Country")
worldOnlineVoters <- worldOnlineVoters[order(worldOnlineVoters$order), ]

# Overlay

plot1 <- p + geom_polygon(data=worldOnlineVoters, aes(x=long, y=lat, group = group, fill = intPen), colour = "green") +
  scale_fill_gradient(low = "black", high = "green",
                      labels = scales::percent_format(),
                      limits = c(0,1),
                      name = "Internet\nPenetration") +
  ggtitle("Internet Penetration in Elections 2016-2018") +
  theme(plot.title = element_text(size = 20, margin = unit(c(0, 0, 5, 0), "mm"))) +
  scale_y_continuous(name=NULL, breaks=NULL, expand = c(0,0)) +
  scale_x_continuous(name=NULL, breaks=NULL, expand = c(0,0)) +
  theme(legend.justification = c(0, 0),
        legend.position = c(0, 0.45),
        legend.background = element_rect(fill = "gray100", size = 0.5, colour = "gray40"),
        legend.title = element_text(size = rel(1.1)),
        legend.text = element_text(size = rel(1.1)))





# Alternatives
p + geom_polygon(data=worldOnlineVoters, aes(x=long, y=lat, group = group, colour = intPen)) +
  scale_colour_gradient(low = "black", high = "green")

p + geom_polygon(data=worldOnlineVoters, aes(x=long, y=lat, group = group, fill = intPen)) +
  scale_colour_continuous(black2green)

p + geom_polygon(data=b, aes(x=long, y=lat, group = group, fill = 2014),
                 colour = "white", fill = "grey10")
