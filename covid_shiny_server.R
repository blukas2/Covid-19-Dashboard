
server <- function(input, output, session) {
  # worldmap
  output$wmap <- renderPlot({
    f_worldMapChart(indicator=input$indic_wmap, continentName = input$continent_wmap)
  })
  
  # country page
  output$cpage <- renderPlot({
    f_basicChart(countryName=input$c_country, 
                 startDate=input$date_cpage[1], endDate=input$date_cpage[2])
  })
  output$cpage_tests <- renderPlot({
    f_testCountryChart(countryName=input$c_country,
                       startDate=input$date_cpage[1], endDate=input$date_cpage[2])
  })
  
  # country compare
  output$ccompare <- renderPlot({
    f_compareChart(countryList=input$c_compare, indicator = input$indic_compare,
                   startDate=input$date_compare[1], endDate=input$date_compare[2])
  })
  
  # barcharts
  output$bar <- renderPlot({
    f_barChart(continentName = input$continent_bar, indicator = input$indic_bar, 
               countryNumber = input$slid_bar)
  })
  
}

