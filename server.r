
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

tweetmine <- function(myword, mycount){
        #Setting up oauth keys
        api_key <- "Your Twitter API Key"
        api_secret <- "Your Twitter API Secret Key"
        access_token <- "Your Twitter access_token"
        access_token_secret <- "Your twitter access_token_secret"
        #doing oauth of twitter
        #setup_twitter_oauth(api_key, api_secret)
        setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)
        # harvest some tweets
        some_tweets <- searchTwitter(myword, n=mycount, lang="en")
        # get the text
        some_txt <- sapply(some_tweets, function(x) x$getText())
        # remove retweet entities
        some_txt <- gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", some_txt)
        # remove at people
        some_txt <- gsub("@\\w+", "", some_txt)
        # remove punctuation
        some_txt <- gsub("[[:punct:]]", "", some_txt)
        # remove numbers
        some_txt <- gsub("[[:digit:]]", "", some_txt)
        # remove html links
        some_txt <- gsub("http\\w+", "", some_txt)
        # remove unnecessary spaces
        some_txt <- gsub("[ \t]{2,}", "", some_txt)
        some_txt <- gsub("^\\s+|\\s+$", "", some_txt)
        #Removing Line breaks
        some_txt <- gsub("[\r\n]", "", some_txt)
        #Removing non graphical characters so that data can be processed by tm package
        some_txt <- str_replace_all(some_txt,"[^[:graph:]]", " ") 
        return(some_txt)
}

tweetclean <- function(x){
        myCorpus <- Corpus(VectorSource(x))
        myCorpus <- tm_map(myCorpus, tolower)
        myCorpus <- tm_map(myCorpus, PlainTextDocument)
        myCorpus <- tm_map(myCorpus, removePunctuation)
        myCorpus <- tm_map(myCorpus, removeNumbers)
        myCorpus <- tm_map(myCorpus, removeWords, stopwords("english"))
        myCorpus <- tm_map(myCorpus, stemDocument)
        return(myCorpus)
}

shinyServer(
        #Whatever computation happen here is used by ui.r to produce in main panel
        function(input, output){
                #Reactive function
                myword <- reactive({
                        as.character(input$word)
                })
                mycount <- reactive({
                        as.numeric(input$tweetcount)
                })
                mydisplaycount <- reactive({
                        as.numeric(input$displaytweet)
                })
                tweets <- reactive({tweets <- tweetmine(myword(), 
                                                        mycount())
                })
                finaldata <- reactive({finaldata <- tweetclean(tweets())
                })
                output$wordcloud <- renderPlot({
                        wordcloud(finaldata(), 
                                  scale=c(5,0.5), 
                                  max.words=100, 
                                  random.order=FALSE, 
                                  rot.per=0.35, 
                                  use.r.layout=FALSE, 
                                  colors=brewer.pal(8, 
                                                    "Dark2"))
                })
                output$data <- renderPrint({
                        head(tweets(), mydisplaycount())
                })
        }
)