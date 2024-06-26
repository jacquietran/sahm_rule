library(shiny)

# Define UI --------------------------------------------------------------------

ui <- fluidPage(
  
  # App title
  titlePanel("Sahm rule"),
  
  # Sidebar
  sidebarLayout(
    sidebarPanel(
      
      # Inputs
      fluidRow(
        column(10,
               selectInput(
                 inputId = "country",
                 label = h3("Choose a country"),
                 # Replace hard-coded choices
                 choices = c("New Zealand",
                             "Australia"),
                 selected = "New Zealand"))
      )
    ),
    
    # Main panel
    mainPanel(
      
      # Outputs
      plotOutput("sahm_plot")
      
    )
  )
)

# Define server logic ----------------------------------------------------------

server <- function(input, output) {
    
    
    
  }



# Run the app ------------------------------------------------------------------

shinyApp(ui = ui, server = server)