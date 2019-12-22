library(shiny)
source('analysis.R')

source("app_ui.R")
source("app_server.R")

shinyApp(ui = ui, server = server)
