diffs <- read.csv("csv/devs3.csv", sep = ',', header = TRUE, row.names = NULL)
devs <- read.csv("csv/Id_Project.csv", sep = ',', header = TRUE, row.names = NULL)

newdiffs <- merge(diffs, devs, by.x="PullNo", by.y="PullNo", all.x = T)
write.csv(newdiffs, "csv/devs32.csv", quote=TRUE, row.names=FALSE)