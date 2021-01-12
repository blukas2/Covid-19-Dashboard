# managing folders
dir_data = (file.path(getwd(), "data"))
if (!dir.exists(dir_data)){dir.create(dir_data)}


####################
# DOWNLOADING DATA
###################


rawData <- fh_dataDownloader(filename = "rawData.csv",
                             downloaderKey = "https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv")

################
# RESHAPE DATA
###############

countryData <- rawData %>%
  filter(location != "World",
         location != "International") %>%
  rename(country = location) %>%
  mutate(date = as.Date(as.character(date), tryFormats = c("%Y-%m-%d")),
         new_tests_smoothed_per_million = new_tests_smoothed_per_thousand*1000)

# last updated
lastUpdate = max(countryData$date)
lastData = lastUpdate-1

# load country name mapping for world map data
countryNameMappingWorld = read.csv("countryWorldMapper.csv", sep = ";")


world_map_continents <- map_data('world') %>%
  left_join(countryNameMappingWorld, by = ("region")) %>%
  left_join(fh_getLatestData("total_cases"), by = "country") %>%
  select(region, country, continent)




# indicator list for shiny app dropdown menus
# indicator "translations"
indicatorNames <- data.frame("indic" = c("total_cases", "total_deaths", 
                                         "new_cases", "new_deaths",
                                         "new_cases_smoothed", "new_deaths_smoothed", 
                                         "total_cases_per_million", "total_deaths_per_million", 
                                         "new_cases_smoothed_per_million", "new_deaths_smoothed_per_million",
                                         "total_vaccinations_per_hundred"), 
                             "realName" = c("Confirmed cases", "Deaths", 
                                            "Daily new cases", "Daily deaths", 
                                            "Daily new cases (7-day movav)", "Daily deaths (7-day movav)",
                                            "Confirmed cases per 1M pop", "Deaths per 1M pop",
                                            "Daily new cases per 1M pop (7-day movav)", "Daily deaths per 1M pop (7-day movav)",
                                            "Total vaccinations per 100 pop"
                                            ))

# convert to named list
indic_list <- as.list(setNames(indicatorNames$indic, indicatorNames$realName))

# country list
countryList <- unique(countryData$country)

# continent list
continentList <- append(unique(countryData$continent), "World")



