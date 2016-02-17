# Online Voters
#
# Aggregated data on online voters and elections

# Load current datasets
load("data/internetPenetration.Rda")
load("data/upcomingElections.Rda")

# Reshape internet penetration data to wide format
library(reshape2)
intPenCast <- dcast(internetPenetration, country ~ year,
                    value.var = "IT.NET.USER.P2")

# MERGE: internetPenetration & upcomingElections --------------------------


onlineVoters <- merge(upcomingElections, intPenCast, by.x = "Country", by.y = "country")

# Check unique countries
check <- data.frame(table(onlineVoters$Country))
check <- subset(check, Freq > 0)

# Mismatched country name fix
fix.1 <- upcomingElections[upcomingElections["Country"] == "Cape Verde",]
fix.2 <- intPenCast[intPenCast["country"] == "Cabo Verde", ]
fix.3 <- cbind(fix.1, fix.2[, -1])

onlineVoters <- rbind(onlineVoters, fix.3)

use_data(onlineVoters, overwrite = T)
