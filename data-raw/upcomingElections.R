# Election Guide Data - Upcoming Elections --------------------------------
###
# NOTE:
# Must run in parts to allow broswer time to open.
# If it fails try running it again.


# Upcoming elections data from - http://www.electionguide.org/elections/upcoming/
library(RSelenium)

# Set up remote server
checkForServer()
startServer()
remDr <- remoteDriver$new()
remDr$open(silent = TRUE)                                  # Open browser (Takes awhile)
url <- "http://www.electionguide.org/elections/upcoming/"  # Define URL
remDr$navigate(url)                                        # Navigate to url

upcoming <- list()
for (i in 1:9){
  doc <- htmlParse(remDr$getPageSource()[[1]])      # Download current wp
  upcoming[[i]] <- readHTMLTable(doc)$datagrid      # Extract table

  searchID <- '//*[@id = "datagrid_next"]'        # Define searchID
  webElem <- remDr$findElement(value = searchID)  # Identify searchID
  webElem$clickElement()                          # Click searchID
}

upcoming <- upcoming[!duplicated(upcoming)]       # Delete duplicates
upcoming <- do.call(rbind.data.frame, upcoming)   # Reshape into data.frame
upcomingElections <- upcoming[, -1]               # Delete blank column and rename

use_data(upcomingElections)
