#!usr/bin/Rscript

###Extract the number of user's all queries among the all sessions
###To get population: f1.val 

###Some primary settings
#setwd("")
#system(“ls *.bd”)
#...
options(max.print=50)

###Load package
is.installed <- require(sqldf)

###Choose DB to write. Please, remember to run your script for smaller DB first
base <- "./dataset.db"

###Set connection
db <-dbConnect(SQLite(), dbname=base)
dbListTables(db) 

###DB writing
extractFeature  <- function(tb.name, f.name) {

  sqldf(sub("\\%",tb.name,"DROP TABLE IF EXISTS %"),connection=db)  
  
  sqldf(paste("CREATE TABLE ",tb.name, " as 
				SELECT user_id as id,
					COUNT(QA.id) as ", f.name, 
				" from 
                                   session S 
				LEFT JOIN query_action QA on S.id=QA.session_id
				GROUP BY user_id"),connection=db)  
  
 sqldf(sub("\\%",tb.name,"SELECT * from %"),connection=db) 
} 

###Choose standard table and feature name, please
extractFeature(tb.name ="f1",f.name="val")

###Close connection
dbDisconnect(db)

