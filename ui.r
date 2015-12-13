
library(shiny)
library(twitteR) 
library(sentiment)
library(plyr)
require(shiny)
require(twitteR) 
require(sentiment)
require(plyr)
require(ggplot2)
require(wordcloud)
require(RColorBrewer)
require(httpuv)
require(RCurl)
require(tm)
require(RColorBrewer)
require(base64enc)
require(stringr)
require(SnowballC)

#Define the UI for the Shiny application here

shinyUI(fluidPage(
        #Application title
        titlePanel(title = h1("Twitter Sentiment Analysis", align = "center")),
        
        #Sidebar layout
        sidebarLayout(
                #sidebar panel: COntains widgets to get data from user
                sidebarPanel(h3("Enter Data to Start Mining"),
                             textInput("word", 
                                       "Enter your word", ""),
                             radioButtons("displaytweet", 
                                          "Select Number of Tweets to Read", 
                                          list("10", "20", "30")),
                             sliderInput("tweetcount", 
                                         "Select Number of Tweets to Mine", 
                                         min = 100, 
                                         max = 1000, 
                                         value = 500,
                                         step = 50),
                             submitButton("Update"),
                             p("Click Update to Load Data")
                             ),
                
                #Main panel: Where the output will be displayed
                mainPanel(h2("Twitter Data", align = "center"),
                          tabsetPanel(type = "tab",
                                      tabPanel("Top Tweets", verbatimTextOutput("data")),
                                      tabPanel("Word Cloud", plotOutput("wordcloud")),
                                      tabPanel("Documentation", 
                                               h2("Data Product Course Data Science Specialization Coursera - Final Project"),
                                               h4("Author: Avinash Singh Pundhir"),
                                               h3("Introduction"),
                                               p("* This is an app that can be used for mining tweets posted on twitter website"),
                                               p("* Users can read top tweets based on a specific search and can draw see a word cloud"),
                                               h3("Functionalities"),
                                               p("* In the text input box enter the word that you want to search on twitter."),
                                               p("* This must be a single word without special characters."),
                                               p("* Select the radio box to access top 10/20/30 tweets from the top of the list."),
                                               p("* Using the slider you can select total number of tweets that should be pulled for the analysis."),
                                               p("* Once all the values are selected hit update to fetch data."),
                                               h3("Userinterface"),
                                               p("* First tab of application will display top 10/20/30 tweets based on user selection."),
                                               p("* Second tab will draw a word cloud to give an understanding how the various words are being used in the context."),
                                               p("* Third tab outlines the documentation on how to use the application.")))
                )
        )
))