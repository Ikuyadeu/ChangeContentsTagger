diffs <- read.csv("csv/devs2.csv", sep = ",", header = TRUE, row.names = NULL)

cols <- c("#FF0000", "#00FF00", "#0000FF",
          "#FFFF00", "#FF00FF", "#00FFFF", "#888888", "#FFFFFF", "#FF8800")

maxexp <- 50
# maxexp <- max(diffs$exp)
diffs <- subset(diffs, exp < maxexp)

numerator.names <- c("NewLine", "If", "Comment",
                     "L_SpaceOrTab", "L_UpperOrLower", "L_Symbol",
                     "L_Renamed", "Moved", "RenameFile")
numerator.names2 <- c("NewLine", "If", "Comment",
                     "SpaceOrTab", "UpperOrLower", "Symbol",
                     "Renamed", "Moved", "RenameFile")
projects <- c("qt/qtbase", "qt-creator/qt-creator", "qt/qtdeclarative")
# projects <- c("qt/qtbase")
for (j in 1:length(projects)){
  proj <- projects[j]
  diffs2 <- subset(diffs, diffs$project == proj)
 
  proj <- gsub("/", "-", proj)
  for (i in 1:length(numerator.names)) {
      numerator.name <- numerator.names[i]
      nn2 <- numerator.names2[i]
      # print(length(diffs$exp))
      # print(length(diffs[,numerator.name]))
      # plot(x = diffs$exp, y = diffs[,numerator.name], 
      #      xlim = c(0.0, maxexp), ylim = c(0.0, maxexp),
      #      xlab = "experience", ylab = "Miss", col = cols[i])
      # boxplot(NewLine~exp, data = diffs, 
      #      xlim = c(0.0, maxexp), ylim = c(0.0, maxexp),
      #      xlab = "experience", ylab = "Miss")
      # diffs[,numerator.name]???<- diffs[,numerator.name] / diffs$exp
      #pdf(paste("plot/", numerator.name, "5.pdf", sep = ""))
      # peoplenum <- data.frame(xp = unique(diffs2$exp), yp = )
      # yp <- unique(diffs2$exp)

      # print(prop.table(table(diffs2$exp, diffs2[,numerator.name]), margin = 2))
      barplot(   prop.table(table(diffs2$exp, diffs2[, numerator.name]), margin = 2)[, 1],
              xlim = c(0.0, maxexp), ylim = c(0.0, 0.1),
              xlab = "experience", ylab = nn2, col = cols[i], cex.lab = 1.2, cex.axis = 2)
      dev.copy2eps(file = paste("R/plot/", proj, "/", nn2, "3.eps", sep = ""))
     
      dev.off()
  }
}
  # legend("topleft", legend = numerator.names, fill = cols, cex = 1.0)