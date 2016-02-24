# InternetPenetration
World Bank Internet Penetration Data (Internet Users)

![Internet Penetration 2014][42]

[42]: images/2014.png "Internet Penetration 2014"

### Getting Started
Install and load the package via R (includes graphing functions and data):
```
devtools::install_github("gitronald/InternetPenetration")
library(InternetPenetration)
```
Select year and plot Internet penetration:
```
ggplot_intpen(2014)
ggplot_intpen(2013)

```
