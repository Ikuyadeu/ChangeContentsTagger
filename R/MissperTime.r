library(xts)
diffs <- read.csv("csv/devs32.csv", sep = ',', header = TRUE, row.names = NULL)

# cols <- c("#FF0000", "#00FF00", "#0000FF",
#           "#FFFF00", "#FF00FF", "#00FFFF", "#888888")

diffs$Date <- as.Date(diffs$Date)
# par(family = "HiraKakuProN-W3")
# par(family = "Japan1GothicBBB")
numerator.names <- c("Comment", "If", "Moved","NewLine",
                     "L_Renamed", "RenameFile", "L_SpaceOrTab",  "L_Symbol", "L_UpperOrLower")
numerator.names <- c("Comment", "If", "Moved","NewLine",
                     "L_Renamed", "RenameFile", "L_SpaceOrTab",  "L_Symbol", "L_UpperOrLower")
# numerator.names2 <- c("Comment     ", 
#                       "If          ", 
#                       "Moved       ",
#                       "NewLine     ",
#                       "Renamed     ",
#                       "RenameFile  ",
#                       "SpaceOrTab  ",
#                       "Symbol      ",
#                       "UpperOrLower")
projects <- c("qt/qtbase", "qt-creator/qt-creator")
for(j in 1:length(projects)){
  proj = projects[j]
  diffs2 <- subset(diffs,diffs$project == proj)
  proj <- gsub("/", "-", proj)
  for (i in 1:length(numerator.names)) {
      numerator.name <- numerator.names[i]
      bts <- apply.quarterly(xts(diffs2[,numerator.name], diffs2$Date), mean)
      if (i==1){
          ts <- bts
      } else {
          ts <- na.locf(merge(ts, bts))
      }
  }
  #diffs$per.lines.numerators <- diffs$NewLine + diffs$If + diffs$Comment + diffs$L_SpaceOrTab + diffs$L_UpperOrLower + diffs$L_Symbol + diffs$L_Renamed
  #bts <- apply.quarterly(xts(diffs$per.lines.numerators, diffs$Date), mean)
  #ts <- na.locf(merge(ts, bts))
  #numerator.names <- append(numerator.names, "ALL")
  #cols <- append(cols, "#000000")

  plot.zoo(ts, ylim = c(0, 1.0), plot.type = "single",type="b", ylab = "Small Change Ratio", 
           xlab = "Date", cex.lab=1.5,
           cex.axis=2.0, lty=1:7,
           pch = 1:7)
　legend("topright", legend = numerator.names, lty=1:7, pch=1:7, cex = 1.2)
           
   dev.copy2eps(file=paste("/Users/yuki-ud/Documents/Paper/OSSresearch-SuperTeam/Review/Domestic/SES2017_Ueda/draft/fig/",proj, "/Time.eps", sep = ""))
  
   dev.off()
}