
run <- function(text){
  load("/var/FastRWeb/web.R/rdata/fp_model_test.Rdata")
  text.cleansed <- text.cleansed <- remove.word(text, "@")
  text.cleansed <- clean.text(text.cleansed)
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
