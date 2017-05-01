diffs <- read.csv("csv/diff.csv", sep = ',', header = TRUE, row.names = NULL)
devs <- read.csv("csv/qt_reviewOwner.csv", sep = ',', header = TRUE, row.names = NULL)

newdiffs <- merge(diffs, devs, by.x="PullNo", by.y="patchId", all.x = T)
write.csv(newdiffs, "newdiffs.csv", quote=TRUE, row.names=FALSE)