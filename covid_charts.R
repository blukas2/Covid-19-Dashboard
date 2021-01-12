################
# style config #
################
# named list containing style elements
styleConfig <- data.frame(
  "styleElement" = c("chartLineSize", "chartAxisYFontSize", "chartAxisXFontSize",
                     "chartTitleSize", "barAxisYFontSize", "barAxisXFontSize"),
  "styleValue" = c(1, 12, 12,
                   14, 12, 12) 
)
styleConfig <- as.list(setNames(styleConfig$styleValue,styleConfig$styleElement))


#############
# world map #
#############

f_worldMapChart <- function(indicator = "total_deaths_per_million", continentName = "World"){
  
  if (continentName == "World"){
    world_data <- map_data('world') %>%
      left_join(countryNameMappingWorld, by = ("region")) %>%
      left_join(fh_getLatestData(indicator), by = "country")
  } else {
    selected_countries <- world_map_continents %>%
      filter(continent == continentName)
    selected_countries <- unique(selected_countries$region)
    
    world_data <- map_data('world', region = selected_countries) %>%
      left_join(countryNameMappingWorld, by = ("region")) %>%
      left_join(fh_getLatestData(indicator), by = "country")
  }
  
  # set theme
  my_theme <- function () { 
    theme_bw() + theme(panel.grid.major = element_blank(), 
                       panel.grid.minor = element_blank(),
                       panel.background = element_blank(), 
                       legend.position = "bottom",
                       legend.title = element_text(size = 14),
                       legend.text = element_text(size = 12),
                       panel.border = element_blank(), 
                       strip.background = element_rect(fill = 'white', colour = 'white'))
  }
  # other theme settings
  # variable name
  nameLegend <- indicatorNames %>%
    filter(indic == indicator)
  nameLegend = nameLegend$realName[[1]]
  
  # colorscheme setting
  colorscheme = fh_colorscheme(indicator)
  
  # colorbar settings
  # it put 3 labels on the colorbar dividing it to 4 pieces
  indic_max = max(world_data[[indicator]], na.rm = TRUE)
  rounding_factor = (nchar(floor(indic_max))-2)*(-1)
  colorbar_labels = c(round(indic_max/4*1, digits = rounding_factor),
                      round(indic_max/4*2, digits = rounding_factor),
                      round(indic_max/4*3, digits = rounding_factor))
  
  # limits
  xMin = ifelse(continentName == "Oceania", 100, min(world_data$long, na.rm = TRUE))
  xMax = ifelse(continentName == "Europe", 50, 
                ifelse(continentName == "North America", -40 ,max(world_data$long, na.rm = TRUE)))
  
  yMin = ifelse(continentName == "World", -60,
                ifelse(continentName == "Africa", -35, min(world_data$lat, na.rm = TRUE)))
  yMax = ifelse(continentName == "Europe", 72, max(world_data$lat, na.rm = TRUE))
  
  # the plot
  plot <- ggplot() + 
    geom_polygon_interactive(data = world_data, color = 'gray70', size = 0.1,
                             aes(x = long, y = lat, fill = get(indicator), group = group, 
                                 tooltip = sprintf("%s<br/>%s", country, get(indicator)))) + 
    scale_fill_gradient(name = nameLegend, low = "white", high = colorscheme, na.value = 'white',
                        labels = colorbar_labels, breaks = colorbar_labels) + 
    scale_x_continuous(limits = c(xMin, xMax), breaks = c()) + 
    scale_y_continuous(limits = c(yMin, yMax), breaks = c()) + 
    coord_fixed(1.3) +
    xlab(NULL) +
    ylab(NULL) +
    my_theme() +
    guides(fill=guide_colorbar(barwidth = 15))
  return(plot)
  
}


################
# COUNTRY PAGE #
################

f_basicChart <- function(countryName, startDate = "2020-03-01"){
  # shows daily new cases and deaths per million people (7-day movav)
  inputData <- countryData %>%
    filter(country == countryName,
           date >= as.Date(startDate)) %>%
    select(date, new_cases_smoothed_per_million, new_deaths_smoothed_per_million)
  scaleRatio = max(inputData$new_cases_smoothed_per_million, na.rm = TRUE)/max(inputData$new_deaths_smoothed_per_million, na.rm = TRUE)
  
  plot <- ggplot(data = inputData, aes(x=date)) +
    geom_line(aes(y=new_cases_smoothed_per_million), 
              color = "red", size = as.numeric(styleConfig[["chartLineSize"]])) +
    geom_line(aes(y=new_deaths_smoothed_per_million*scaleRatio), 
              color = "black", size = as.numeric(styleConfig[["chartLineSize"]])) +
    scale_y_continuous(limits = c(0, NA), sec.axis = sec_axis(~./scaleRatio, name = "")) +
    scale_x_date(date_breaks = "1 month", date_labels = "%b") +
    xlab("") +
    ylab("") +
    ggtitle("Daily new cases per million (red) & new deaths (black)") +
    theme(title = element_text(size=as.numeric(styleConfig[["chartTitleSize"]])),
          axis.text.x = element_text(size=as.numeric(styleConfig[["chartAxisXFontSize"]])),
          axis.text.y = element_text(size=as.numeric(styleConfig[["chartAxisYFontSize"]]), color = "red"),
          axis.text.y.right = element_text(size=as.numeric(styleConfig[["chartAxisYFontSize"]]), color = "black"))
  return(plot)
}


f_testCountryChart <- function(countryName){
  # shows daily new tests per million people and daily positive rate (7-day movav)
  inputData <- countryData %>%
    filter(country == countryName,
           positive_rate <= 1) %>%
    select(date, new_tests_smoothed_per_million, positive_rate)
  
  scaleRatio = max(inputData$new_tests_smoothed_per_million, na.rm = TRUE)/max(inputData$positive_rate, na.rm = TRUE)
  
  plot <- ggplot(data = inputData, aes(x = date)) +
    geom_col(aes(y = new_tests_smoothed_per_million, color = "New tests per \n 1M pop"), fill = "blue3") +
    geom_line(aes(y = positive_rate*scaleRatio, color = "Positive per \n ths tests"),
              size=as.numeric(styleConfig[["chartLineSize"]])) +
    scale_colour_manual("", 
                        breaks = c("", ""),
                        values = c("blue3", "red")) +
    ylab("") +
    xlab("") +
    ggtitle("Daily tests per million people (blue) & positive rate (red)") +
    scale_y_continuous(limits = c(0, NA) , sec.axis = sec_axis(~./scaleRatio, name = "", labels = percent)) +
    scale_x_date(date_breaks = "1 month", date_labels = "%b") +
    theme(title = element_text(size=as.numeric(styleConfig[["chartTitleSize"]])),
          axis.text.x = element_text(size=as.numeric(styleConfig[["chartAxisXFontSize"]])),
          axis.text.y = element_text(size=as.numeric(styleConfig[["chartAxisYFontSize"]]), color = "blue3"),
          axis.text.y.right = element_text(size=as.numeric(styleConfig[["chartAxisYFontSize"]]), color = "red"))
  return(plot)
}


#####################
# COMPARE COUNTRIES #
#####################

f_compareChart <- function(countryList, indicator = "total_deaths_per_million", startDate = "2020-03-01"){
  # compare multiple countries along a custom metric
  inputData <- countryData %>%
    filter(country %in% countryList,
           date >= as.Date(startDate)) %>%
    select("date", "country", indicator)
  
  # fixed color palette so the coloring of countries would not change when the selection is modified
  color_palette <- hue_pal()(8)
  
  # indicator name translations - out of use
  nameIndicator <- indicatorNames %>%
    filter(indic == indicator)
  nameIndicator = nameIndicator$realName[[1]]
  
  plot <- ggplot(data = inputData, aes(x=date)) +
    geom_line(aes(y=get(indicator), color = country), size=as.numeric(styleConfig[["chartLineSize"]])) +
    scale_x_date(date_breaks = "1 month", date_labels = "%b") +
    scale_colour_manual("", 
                        values = color_palette[1:length(countryList)],
                        breaks = countryList) +
    xlab("") +
    ylab("") +
  theme(axis.text.x = element_text(size=as.numeric(styleConfig[["chartAxisXFontSize"]])),
        axis.text.y = element_text(size=as.numeric(styleConfig[["chartAxisYFontSize"]])))
  return(plot)
  
}


f_barChart <- function(continentName = "World", indicator = "total_deaths_per_million", countryNumber = 20){
  # shows the top n countries along a custom indicator
  # countryList: "all" - all countries; or a character vector of selected countries -not implemented yet
  
  # drop city-states
  countryList <- countryData %>%
    filter(population>100000)  
  
  if (continentName != "World") {
    countryList <- countryList %>%
      filter(continent==continentName)
  }
  countryList = unique(countryList$country)
  
  
  inputData <- fh_getLatestData(indicator) %>%
    filter(country %in% countryList) %>%
    arrange(desc(get(indicator))) %>%
    head(countryNumber)
  
  nameIndicator <- indicatorNames %>%
    filter(indic == indicator)
  nameIndicator = nameIndicator$realName[[1]]
  
  colorscheme = fh_colorscheme(indicator)
  
  plot <- inputData %>%
    ggplot(aes(x = reorder(country, get(indicator)), y = get(indicator))) +
    geom_col(fill = colorscheme) +
    coord_flip() +
    xlab("") +
    ylab("") +
    theme(axis.text.y = element_text(size = as.numeric(styleConfig[["barAxisYFontSize"]])),
          axis.text.x = element_text(size = as.numeric(styleConfig[["barAxisXFontSize"]])))
  
  return(plot)
  
}
