library(shiny)
library(plotly)

source('analysis.R')

server <- function(input, output) {
  output$us_map_7 <- renderPlot(
    draw_us_sleep_map()
  )
  output$us_timeline <- renderPlot(
    draw_sleep_trend_plot(input$StudiesMethods)
  )
  output$pie_chart <- renderPlotly(
    draw_pie()
  )
  output$compared.bar <- renderPlotly(
    draw_compare_line(input$select.activities)
  )
  output$sleep_impacts <- renderPlot(
    plot_impacts(input$age, input$symptoms)
  )
  output$sleep_GPA <- renderPlotly({
    return(draw_bar_graph_gpa_tired())
  })
  output$years_old <- renderText({
    age_statement(input$age_years)
  })
  output$awake <- renderText({
    wake_statement(input$awake_time)
  })
  output$sleep_time <- renderText({
    calculate_sleep(input$age_years, input$awake_time)
  })
  output$pvu <- renderImage({
    return(list(
      src = "pvu.jpg",
      contentType = "image/jpg",
      height = 200
    ))
  }, deleteFile = FALSE)
  output$ychen <- renderImage({
    return(list(
      src = "ychen.jpg",
      contentType = "image/jpg",
      height = 200
    ))
  }, deleteFile = FALSE)
  output$hcao <- renderImage({
    return(list(
      src = "hcao.jpg",
      contentType = "image/jpg",
      height = 200
    ))
  }, deleteFile = FALSE)
  output$vlaw <- renderImage({
    return(list(
      src = "vlaw.jpg",
      contentType = "image/jpg",
      height = 200
    ))
  }, deleteFile = FALSE)
}
