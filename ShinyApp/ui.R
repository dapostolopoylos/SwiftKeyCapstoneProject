library("shiny")
library("stringi")
library("sqldf")
library("wordcloud")
library("ggplot2")

shinyUI(fluidPage(
  
     
  titlePanel("Predict the next word"),
  
  navbarPage("Menu",
             
             tabPanel("About",
                           sidebarPanel(p(span('This application is the final part of the '), 
                                          a("Data Sciense Specialization",href="https://www.coursera.org/specializations/jhu-data-science",target="_blank"),
                                          span(", provided by Coursera and JHU")),
                                        p(span('It was created by'),
                                          strong('Dimitrios Apostolopoulos'),
                                          span(', BI Engineer since 2005, avid Coursera student since 2015 and Data Scientist to be.')),
                                        p(span('You can find me in:'),br(),br(),
                                          a(img(src = 'twitterLogo.png', height = 50, width = 60),href="https://twitter.com/dapostolopoylos",target="_blank"),
                                          a(img(src = 'linkedinLogo.png', height = 50, width = 60),href="https://www.linkedin.com/in/dapostolop",target="_blank"))
                           ),
                      
                           mainPanel(
                                h1("Data Science Specialization Capstone Project"),
                                h3("About"),
                              p(
                              span("This is the Capstone Project for the Data Sciense Specialization provided by JHU and Coursera with the cooperation of SwiftKey."),     
                               br(),br(),
                               span("This application was made using all the skills learned during the courses of the Data Sciense Specialization and also 
                                    the knowledge gained studying on Text Mining. The purpose of this application is to create an algorith that will be able
                                    to give logical predictions for the next word that a user will type into an input box. To achieve that there was a process
                                    of obtaining the data, understandintg their structure, purify them from unnecessary elements, create patterns on the ways
                                    they appear and the combination between them. All this work ends up to this application where the user inputs some words, hits 
                                    the submit button and the application predicts up to three words according to the user input that could be the next for his input."),
                               br(),br(),
                               h3("How to use"),
                               p("The application is split in two panels, the input panel on the left side and the output panel on the right side.
                                 The user types in the input box a sentense that has to have a length equal or greater than of one word, then he hits the submit button.
                                 If the sentense is smaller than one word a proper message will be printed on the screen. If not, on the output panel of the
                                 application there will be printed the three most probable next words for the user's sentense and a bar chart that will
                                 show the frequensies for every word. If the user would like to make another prediction all he has to do is to type a new sentense 
                                 in the input box."),
                               h3("Links"),
                               strong("*"),span("  The full code created for this application can be found in this "),a("Git Hub repository.",href="https://github.com/dapostolopoylos/SwiftKeyCapstoneProject",target="_blank"),
                               br(),
                               strong("*"),span("  A slide deck presentation created for this application can be found in "),a("RPubs.",href="",target="_blank"),
                               br(),
                               strong("*"),span("  The website of "),a("JHU",href="https://www.jhu.edu/",target="_blank"),".",
                               br(),
                               strong("*"),span("  The website of "),a("Coursera",href="https://www.coursera.org/",target="_blank"),".",
                               br(),
                               strong("*"),span("  The website of "),a("SwiftKey",href="https://swiftkey.com/en",target="_blank"),"."
                              
                                                                  
                               )
                           )
                      ),
             tabPanel("Application",
                          sidebarPanel(width=4,
                                  textInput("txt",label=h4("Text Input"),value="Enter some text...",width="100%"),
                                  hr(),
                                  submitButton("Submit")
                           ),
                           mainPanel(width=8,
                                  h4("Predictions"),
                                  verbatimTextOutput("pred"),
                                  hr(),
                                  plotOutput('plot')
                                  )
                      )
                      )
             
             )
  
)

