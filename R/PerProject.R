csvname <- "devs22.csv"
diffs <- read.csv(paste("csv/", csvname, sep = ""), sep = ',', header = TRUE, row.names = NULL)

projects <- c("qt/qtbase", "qt-creator/qt-creator", "qt/qtdeclarative")

for (i in 1:length(projects)) {
  proj <- projects[i]
  newdiffs <- subset(diffs, diffs$project == proj)
  proj <- gsub("/", "-", proj)
  csvname2 <- paste("csv/QT", proj, "-",csvname, sep = "")
  #write.csv(newdiffs, csvname2, quote=TRUE, row.names=FALSE)  
  print(nrow(newdiffs))
  print(proj)
  print(length(unique(newdiffs$devId)))
}

