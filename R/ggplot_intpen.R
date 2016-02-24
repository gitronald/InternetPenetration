ggplot_intpen <- function(data1 = WorldMapInternetPenetration,
                          year = 2014,
                          gradient.low = "white",
                          gradient.high = "#649AF1") {

  years.char <- as.character(year)
  years <- lapply(year, as.symbol)
  world <- map_data("world")

  for(i in 1:length(years)){
    year <- paste(years[i])
    # Generate Blank World Map

    p <- ggplot() +
      geom_polygon(data=world, aes(x=long, y=lat, group = group),
                   # colour = "gray70",                           # Country boundary outline
                   fill = "#F9F9F9") +                            # Country fill
      theme(panel.background = element_rect(fill = "gray20"),     # Image frame color
            plot.background = element_rect(fill = "gray20"))      # Ocean color

    plot1 <- p + geom_polygon(data=WorldMapInternetPenetration,
                              aes_string(x="long", y="lat", group = "group", fill = year)) +
      scale_fill_gradient(low = "white", high = "#649AF1",
                          labels = scales::percent_format(),
                          limits = c(0,1)) +
      ggtitle(paste("Internet Penetration", gsub("`", "", year))) +
      theme(plot.title = element_text(size = 20, colour = "white", family = "Roboto Medium",
                                      margin = unit(c(0, 0, 5, 0), "mm"))) +
      scale_y_continuous(name=NULL, breaks=NULL, expand = c(0,0)) +
      scale_x_continuous(name=NULL, breaks=NULL, expand = c(0,0)) +
      theme(legend.justification = c(0, 0),
            legend.position = c(0, 0.32),
            #         legend.background = element_rect(fill = "gray20"),
            legend.background = element_blank(),
            legend.title = element_blank(),
            legend.text = element_text(size = rel(1.1), colour = "white", family = "Roboto Medium")) +
      guides(fill = guide_colorbar(barwidth = rel(0.5), barheight = rel(5.0), ticks = F))

    return(plot1)
  }
}
