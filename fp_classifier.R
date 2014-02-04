library(textcat)
library(stringr)

run <- function(text){
  load("/var/FastRWeb/web.R/rdata/fp_model.Rdata")
  # if it starts with RT or has " RT @" in it, it's junk to Raed
  if(grepl("^RT| RT @|[Bb]ieber", text)){
    result <- 0
  }else{    
    text.cleansed <- clean.text(text)
    result <- textcat(text.cleansed, fp.model)
  }  
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
