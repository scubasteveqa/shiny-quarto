library(shiny)

# Define UI for application
ui <- fluidPage(
  titlePanel("Hardcoded Quarto Document Renderer"),
  
  sidebarLayout(
    sidebarPanel(
      actionButton("generate", "Generate and View Document")
    ),
    
    mainPanel(
      uiOutput("rendered_doc"),   # This will render the HTML content
      verbatimTextOutput("status")
    )
  )
)

# Define server logic required to generate and render the document
server <- function(input, output, session) {
  
  # Path to save the generated Quarto document
  output_file <- reactiveVal(NULL)
  
  observeEvent(input$generate, {
    # Create a temporary file for the Quarto document
    temp_dir <- tempdir()
    temp_file <- file.path(temp_dir, "hardcoded.qmd")
    
    # Write hardcoded Quarto content
    fileConn <- file(temp_file)
    writeLines(c(
      "---",
      "title: 'Hardcoded Quarto Document'",
      "author: 'Shiny App'",
      "format:",
      "  html: default",
      "---",
      "",
      "# Introduction",
      "This document was generated with hardcoded content directly from the Shiny app.",
      "",
      "## Section 1",
      "Here is some example content in **Section 1**.",
      "",
      "## Section 2",
      "And here is more content in **Section 2**.",
      "",
      "### A Random List",
      "- Item 1",
      "- Item 2",
      "- Item 3",
      "",
      "## Conclusion",
      "This concludes the hardcoded Quarto document example."
    ), fileConn)
    close(fileConn)
    
    # Render the Quarto document as HTML
    rendered_html <- file.path(temp_dir, "hardcoded.html")
    system(paste("quarto render", temp_file, "--to html"))
    
    # Set the output file path
    output_file(rendered_html)
    
    # Display the generated HTML content in the browser
    output$rendered_doc <- renderUI({
      tags$iframe(src = rendered_html, style = "width:100%; height:600px;")
    })
    
    output$status <- renderText({"Document generated and rendered successfully!"})
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
