
library(textcat)
library(stringr)

replace.links <- function(text){
  # extract urls from string, only works with t.co links, which all links in
  # twitter are nowadays
  return(str_replace_all(text,
                         ignore.case("http://[a-z0-9].[a-z]{2,3}/[a-z0-9]+"),
                         "urlextracted"))
}

remove.word <- function(string, starts.with.char){
  # INPUT:  string is a string to be edited,
  #         starts.with.char is a string or partial string to search and remove
  # OUTPUT: string with words removed
  # USAGE:  remove.word(string, "@") removes words starting with "@"
  #         remove.word(string, "RT") removes RT from string
  word.len <- nchar(starts.with.char)
  list.of.words <- strsplit(string, " ")[[1]]
  # remove ones that start with "starts.with.char"
  list.of.words <- list.of.words[!substring(list.of.words, 1,
                                            word.len)==starts.with.char]
  ret.string <- paste(list.of.words, collapse=" ")
  return(ret.string)
}

# read the manually classified tweets
df <- read.csv("create_model/fp_tweets.csv", stringsAsFactors=F)

# do the preprocessing to the data. this needs to be done before any prediction
# using the model that is created.
df$text.cleansed <- tolower(df$text)
# remove the string "food poisoning" because every tweet has this in it...
df$text.cleansed <- sapply(df$text.cleansed,
                           function(x)gsub("food poisoning", "", x))
df$text.cleansed <- as.character(sapply(df$text.cleansed, replace.links))
df$text.cleansed <- as.character(sapply(df$text.cleansed,
                                        function(x)remove.word(x, "@")))
df$text.cleansed <- as.character(sapply(df$text.cleansed,
                                        function(x)remove.word(x, "rt")))
# replace non-letters with spaces
df$text.cleansed <- as.character(sapply(df$text.cleansed,
                                        function(x)gsub("[^[:alnum:]]", " ", x)))
# remove leading and trailing spaces
df$text.cleansed <- as.character(sapply(df$text.cleansed,
                                        function(x)gsub("^\\s+|\\s+$", "", x)))
# replace multiple spaces next to each other with single space
df$text.cleansed <- as.character(sapply(df$text.cleansed,
                                        function(x)gsub("\\s{2,}", " ", x)))

df <- subset(df, text.cleansed!="")

# train the model using the textcat package
fp.model <- textcat_profile_db(df$text.cleansed, df$manual_class)
# save model file to be used on server 
save(list=c("fp.model", "replace.links", "remove.word"),
     file="fp_model.Rdata")

# test it out...
# textcat("i have the food poisoning", fp.model)
