# functions defining the coloring of charts


fh_colorscheme <- function(indicator){
  # colorscheme by indicators, used for world map and bar charts
  colorscheme = case_when(indicator %in% c("total_deaths", "new_deaths", "new_deaths_smoothed", 
                                           "total_deaths_per_million", "new_deaths_smoothed_per_million") ~ "black",
                          indicator %in% c("total_cases", "new_cases", "new_cases_smoothed", 
                                           "total_cases_per_million", "new_cases_smoothed_per_million") ~ "red4",
                          indicator %in% c("total_vaccinations", "new_vaccinations", "total_vaccinations_per_hundred",
                                           "new_vaccinations_per_million") ~ "violetred4")
  
  return(colorscheme)
}



fh_daysSinceMod <- function(file){
  # get the data then the file was modified
  modifyTime = file.info(file)[1,4]
  modifyDate = as.Date(modifyTime, tz = Sys.timezone())
  modifyDaysPassed = Sys.Date() - modifyDate
  return(as.numeric(modifyDaysPassed))
}


fh_dataDownloader <- function(filename, downloaderKey){
  # if the raw  data file does not exists or it was modified yesterday, 
  # it downloads the data from github otherwise loads it from the local drive 
  if (!file.exists(file.path(dir_data, filename)) | 
      fh_daysSinceMod(file.path(dir_data, filename))>0){
    data_table <- fread(downloaderKey)
    write.csv(data_table, file = file.path(dir_data, filename), row.names = FALSE)
    
  } else {
    data_table <- read.table(file.path(dir_data, filename), header = TRUE, sep = ",",
                             check.names = FALSE) %>%
      mutate(date = as.Date(date, tryFormats = c("%Y-%m-%d")))
  }
  return(data_table)
}

fh_getLatestData <- function(indicator, dayTolerance = 10){
  # get the latest data for one indicator by country
  # it can handle cases when the latest data point is not at the latest date
  dataSet <- countryData %>%
    select("date", "country", indicator) %>%
    filter(!is.na(get(indicator))) %>%
    group_by(country) %>%
    filter(date == max(date))%>%
    ungroup() %>%
    filter(date >= lastUpdate-1-dayTolerance) %>%
    select("country", indicator)
  return(dataSet)
}

