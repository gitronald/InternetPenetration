# World Development Indicators (WDI) Data - Internet Penetration
# World Bank

# Load data
load("data/internetPenetration.Rda")

# Generate Blank World Data longitudes and latitudes
library(ggplot2)
library(maps)
world <- map_data("world")

# Convert internet penetration to percent
internetPenetration$IT.NET.USER.P2 <- internetPenetration$IT.NET.USER.P2/100

# Remove non-country specific data
internetPenetration <- internetPenetration[851:nrow(internetPenetration), ]

# Obtain country names
i.names <- sort(unique(as.character(internetPenetration$country)))
w.names <- sort(unique(as.character(world$region)))

# Detect mismatches
matched <- detect_merge_mismatch(w.names, i.names)

# Check remaining unmatched
# matched[[2]]; matched[[3]]
# Manually match:
manualmatch <- data.frame(matrix(
  c("Cape Verde", "Cabo Verde",
    "Democratic Republic of the Congo", "Congo, Dem. Rep.",
    "Republic of Congo", "Congo, Rep.",
    "Ivory Coast", "Cote d'Ivoire",
    "Kyrgyzstan", "Kyrgyz Republic",
    "Faroe Islands", "Faeroe Islands",
    "North Korea", "Korea, Dem. Rep.",
    "South Korea", "Korea, Rep.",
    "Slovakia", "Slovak Republic",
    "Saint Kitts", "St.Kitts and Nevis",
    "Saint Lucia", "St. Lucia",
    "Saint Martin", "St. Martin (French part)",
    "UK", "United Kingdom",
    "USA", "United States"),
  ncol = 2,
  byrow = T
  ))
names(manualmatch) <- c("var1", "matches")
manualmatch <- apply(manualmatch, 2, as.character)

# Update unmatched
unmatched.w.names <- matched[["missing.var1"]][which(!matched[["missing.var1"]] %in% manualmatch[, "var1"])]
unmatched.i.names <- matched[["missing.var2"]][which(!matched[["missing.var2"]] %in% manualmatch[, "matches"])]
# Replace unmatched with manual matches
matched.final <- rbind(matched[["matched"]], manualmatch)
matched.final <- matched.final[!duplicated(matched.final["var1"], fromLast = TRUE), ]

# Reshape to ordered data.frame
matched.final <- data.frame(var1 = unlist(matched.final$var1),
                            matches = unlist(matched.final$matches),
                            stringsAsFactors = FALSE)
matched.final <- apply(matched.final, 2, as.character)
matched.final <- data.frame(matched.final[order(matched.final[, "var1"]), ],
                            stringsAsFactors = FALSE)

final <- list(matches = matched.final,
              unmatched.world.map = unmatched.w.names,
              unmatched.internet.penetration = unmatched.i.names)


for(i in 1:nrow(matched.final)){
  if(!is.na(matched.final[i, "matches"])){
    old.name <- paste(matched.final[i, "matches"])
    new.name <- paste(matched.final[i, "var1"])
    internetPenetration[, "country"] <- gsub(old.name, new.name, internetPenetration[, "country"])
  }
}

# Reshape internet penetration data to wide format
library(reshape2)
intPenCast <- dcast(internetPenetration, country ~ year,
                    value.var = "IT.NET.USER.P2")

# Merge coordinate data with WDI Internet penetration data
WorldMapInternetPenetration <- merge(world, intPenCast, by.x = "region", by.y = "country")
# Reorder plot points
WorldMapInternetPenetration <- WorldMapInternetPenetration[order(WorldMapInternetPenetration[, "order"]), ]
# Replace NA with zero
WorldMapInternetPenetration[is.na(WorldMapInternetPenetration)] <- 0

# Save data
save(WorldMapInternetPenetration, file = "data/WorldMap-InternetPenetration.Rda")

# Save database of names
WorldMapCountryNames <- matched.final[!is.na(matched.final$matches), ]
save(WorldMapCountryNames, file = "data/WorldMap-CountryNames.Rda")
