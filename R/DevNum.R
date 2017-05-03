diffs <- read.csv("csv/devs22.csv", sep = ',', header = TRUE, row.names = NULL)

maxexp <- 50
projects <- c("qt/qtbase", "qt-creator/qt-creator", "qt/qtdeclarative")

for(j in 1:length(projects)){
  proj = projects[j]
  print(proj)
  diffs2 <- subset(diffs,diffs$project == proj)
  proj <- gsub("/", "-", proj)
  diffs2 <- subset(diffs2, exp < maxexp)
  plot(table(diffs2$exp), ylab = "Developer Num", xlab = "Exp",cex.lab=1.5,cex.axis=2)
  dev.copy2eps(file=paste("R/plot/",proj, "/devnum.eps", sep = ""))
  
  dev.off()
}