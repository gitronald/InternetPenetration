# World Bank Data - Internet Penetration ----------------------------------

# Load World Development Indicators (WDI) package
# to access World Bank API
library("WDI")

# Download all indicators and country codes
key <- WDIcache()

# Search indicators for "internet"
WDI.Internet <- WDIsearch(string = "internet", field = "name")

# Locate variable
# > WDI.Internet
#      indicator        name
# [1,] "IT.NET.BBND"    "Fixed broadband Internet subscribers"
# [2,] "IT.NET.BBND.P2" "Fixed broadband Internet subscribers (per 100 people)"
# [3,] "IT.NET.CONN.CD" "Fixed broadband Internet connection charge (current US$)"
# [4,] "IT.NET.CONN.CN" "Fixed broadband Internet connection charge (current LCU)"
# [5,] "IT.NET.SECR"    "Secure Internet servers"
# [6,] "IT.NET.SECR.P6" "Secure Internet servers (per 1 million people)"
# [7,] "IT.NET.SUB.CD"  "Fixed broadband Internet monthly subscription (current US$)"
# [8,] "IT.NET.SUB.CN"  "Fixed broadband Internet monthly subscription (current LCU)"
# [9,] "IT.NET.USER"    "Internet users"
# [10,] "IT.NET.USER.P2" "Internet users (per 100 people)"
# [11,] "IT.NET.USER.P3" "Internet users (per 1,000 people)"

internetUsers <- WDI.Internet[10, 1]

# Extract data starting in 1990.
internetPenetration <- WDI(country = "all",
                           indicator = internetUsers,
                           start = 1990,
                           end = 2014)

use_data(internetPenetration)
