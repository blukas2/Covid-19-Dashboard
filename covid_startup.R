# libraries
library(data.table)
library(dplyr)
library(tidyr)
library(ggplot2)
library(maps)
library(shiny)
library(maps)
library(ggiraph)
library(scales)

# set working directory
dir_default = "E:\\Data Science\\R\\Covid Dashboard\\v1.0"
setwd(dir_default)

# load helper functions
source("covid_helperFunctions.R")
# load data
source("covid_loadData.R")
# load chart generators
source("covid_charts.R")
# load shiny app components
source("covid_shiny_ui.R")
source("covid_shiny_server.R")

# start ShinyApp
shinyApp(ui = ui, server = server)


