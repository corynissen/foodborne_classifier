
run <- function(text){
  load("/var/FastRWeb/web.R/rdata/fp_model.Rdata")

  text.cleansed <- tolower(text)
  # remove the string "food poisoning" because every tweet has this in it...
  text.cleansed <- gsub("food poisoning", "", text.cleansed)
  text.cleansed <- replace.links(text.cleansed)
  text.cleansed <- remove.word(text.cleansed, "@")
  text.cleansed <- remove.word(text.cleansed, "rt")
  # replace non-letters with spaces
  text.cleansed <- gsub("[^[:alnum:]]", " ", text.cleansed)
  # remove leading and trailing spaces
  text.cleansed <- gsub("^\\s+|\\s+$", "", text.cleansed)
  # replace multiple spaces next to each other with single space
  text.cleansed <- gsub("\\s{2,}", " ", text.cleansed)

  result <- textcat(text.cleansed, fp.model)
  
  if(is.na(result)){
    result.print <- "don't know..."
  }else{
    if(result=="1"){
      result.print <- "food poisoning tweet"
    }else{
      if(result=="0"){
        result.print <- "not a food poisoning tweet"
      }else{
        result.print <- "something is wrong..."
      }
    }
  }
  WebResult(result.print)
}
