diffs <- read.csv("csv/devs32.csv", sep = ",", header = TRUE, row.names = NULL)

cols <- c("#FF0000", "#00FF00", "#0000FF",
          "#FFFF00", "#FF00FF", "#00FFFF", "#888888", "#FFFFFF", "#FF8800")

# maxexp <- 50
# maxexp <- max(diffs$exp)
# diffs <- subset(diffs, exp < maxexp)

numerator.names <- c("Comment", "If", "Moved", "NewLine",
                     "L_Renamed", "RenameFile", "L_SpaceOrTab",  "L_Symbol", "L_UpperOrLower")
numerator.names2 <- c("Comment     ",
                      "If          ",
                      "Moved       ",
                      "NewLine     ",
                      "Renamed     ",
                      "RenameFile  ",
                      "SpaceOrTab  ",
                      "Symbol      ",
                      "UpperOrLower")
projects <- c("qt/qtbase", "qt-creator/qt-creator")
numerator.names <- c("NewLine",
                     "L_SpaceOrTab", "L_UpperOrLower", "L_Symbol",
                     "L_Renamed")
projects <- c("qt/qtbase")
edate <- as.Date("2011-3-1")
diffs$Date <- as.Date(diffs$Date)
pas <- c()
diffs2 <- subset(diffs, diffs$project == projects[1])

print(paste(nrow(diffs2),
nrow(subset(diffs2, diffs2["NewLine"] + diffs2["L_SpaceOrTab"] + diffs2["L_UpperOrLower"] + diffs2["L_Symbol"] + diffs2["L_Renamed"] > 0))))
for (i in 1:length(numerator.names)) {
    numerator.name <- numerator.names[i]
    print(paste(numerator.name,
    nrow(subset(diffs2, diffs2[numerator.name] > 0 & diffs2$Date < edate))/ nrow(subset(diffs2, diffs2$Date < edate)),
    nrow(subset(diffs2, diffs2[numerator.name] > 0 & diffs2$Date >= edate)) / nrow(subset(diffs2, diffs2$Date >= edate)) , sep = " & "))
      # plot(x = diffs$exp, y = diffs[,numerator.name], 
      #      xlim = c(0.0, maxexp), ylim = c(0.0, maxexp),
      #      xlab = "experience", ylab = "Miss", col = cols[i])
      # boxplot(NewLine~exp, data = diffs, 
      #      xlim = c(0.0, maxexp), ylim = c(0.0, maxexp),
      #      xlab = "experience", ylab = "Miss")
      # diffs[,numerator.name]???<- diffs[,numerator.name] / diffs$exp
      #pdf(paste("plot/", numerator.name, "5.pdf", sep = ""))

      # print(prop.table(table(diffs2$exp, diffs2[,numerator.name]), margin = 2)[, 1])
      # barplot(   prop.table(table(diffs2$exp, diffs2[, numerator.name]), margin = 3)[, 1],
      #         xlim = c(0.0, maxexp), ylim = c(0.0, 0.1),
      #         xlab = "experience", ylab = nn2, col = cols[i], cex.lab = 1.2, cex.axis = 2)
      # dev.copy2eps(file = paste("R/plot/", proj, "/", nn2, "3.eps", sep = ""))
      # boxplot((diffs2[,numerator.name])~diffs2$exp,
      #         xlim = c(0.0, maxexp), ylim = c(0.0, maxexp),
      #         xlab = "experience", ylab = nn2, col = cols[i],cex.lab=1.2,cex.axis=2)
      # dev.copy2eps(file=paste("R/plot/",proj,"/", nn2, ".eps", sep = ""))
      
      # dev.off()
}
  # legend("topleft", legend = numerator.names, fill = cols, cex = 1.0)