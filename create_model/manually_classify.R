
# this is a script to help make the manual classification process just a tiny
# bit more tolerable. It shows you a tweet, you press 1 or 0 and it shows
# you the next one. q to quit. it readsin the tweets csv file and saves to the
# same file, don't mess this up man...

# run from command line... Rscript manually_classify.R

dyn.load("create_model/getkey3.so")
df <- read.csv("create_model/fp_tweets.csv", as.is=T, stringsAsFactors=F)
# 113 == q, 49 == 1, 48 == 0

# manually classify
# 1 is good, 0 is bad
for(i in 1:nrow(df)){
  if(is.na(df$manual_class[i])){
    print("1 is good, 0 is bad, q to quit")
    print(df$text[i])
    man_class <- NA
    while(!man_class %in% c(113,49,48))
      {
        man_class <- .C("mygetch",as.integer(0))
        #man_class <- readline("Enter the class here:  ")
        if(man_class==113){
          write.csv(df, "create_model/fp_tweets.csv", row.names=F)
          print("saved")
          stop("you have quit")          
        }
      }
    df$manual_class[i] <- ifelse(man_class==49, 1, 0)
    if(i==nrow(df)){
      print("you have reached the end")
      write.csv(df, "create_model/fp_tweets.csv", row.names=F)
      print("saved")
    }
  }
}
