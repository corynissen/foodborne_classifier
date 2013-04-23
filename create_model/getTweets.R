
library(RMongo)

# create tunnel to mongodb to get data
system("sh mongo_tunnel.sh")
mongo <- mongoDbConnect("db")
username = "username"
password = "password"
authenticated <- dbAuthenticate(mongo, username, password)
dbShowCollections(mongo)
df <- dbGetQuery(mongo, "fp_collection", "{}", 0, 1000000)
df <- subset(df, X_id!="")
df$manual_class <- rep(NA, nrow(df))
write.csv(df, "create_model/fp_tweets.csv", row.names=F)
