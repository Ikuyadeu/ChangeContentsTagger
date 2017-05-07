diffs <- read.csv("csv/devs2.csv", sep = ',', header = TRUE, row.names = NULL)
devs <- read.csv("csv/Id_Project.csv", sep = ',', header = TRUE, row.names = NULL)

newdiffs <- merge(diffs, devs, by.x="PullNo", by.y="PullNo", all.x = T)
write.csv(newdiffs, "csv/devs22.csv", quote=TRUE, row.names=FALSE)