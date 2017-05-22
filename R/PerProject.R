csvname <- "devs32.csv"
diffs <- read.csv(paste("csv/", csvname, sep = ""), sep = ',', header = TRUE, row.names = NULL)

projects <- c("qt/qtbase", "qt-creator/qt-creator", "qt/qtdeclarative")
kinds <- c("NewLine", "If", "Comment", 
                     "L_SpaceOrTab", "L_UpperOrLower", "L_Symbol", "L_Renamed", "Moved", "RenameFile")
print(nrow(diffs))
# diffs <- subset(diffs, diffs$NewLine + diffs$If + diffs$Comment + diffs$L_SpaceOrTab + diffs$L_UpperOrLower + diffs$L_Symbol + diffs$L_Renamed + diffs$Moved + diffs$RenameFile > 0)
# print(nrow(diffs))
for (i in 1:length(kinds)) {
  kind <- kinds[i] 
  print(kind)
  diffs2 <- subset(diffs, diffs[,kind] > 0)
  print(nrow(diffs2))
}
# for (i in 1:length(kinds)) {
#   kind <- kinds[i] 
#   print(kind)
#   diffs2 <- subset(diffs, diffs[,kind] > 0)
#   print(nrow(diffs2))
# }


# for (i in 1:length(projects)) {
#   proj <- projects[i]
#   newdiffs <- subset(diffs, diffs$project == proj)
#   proj <- gsub("/", "-", proj)
#   csvname2 <- paste("csv/QT", proj, "-",csvname, sep = "")
#   #write.csv(newdiffs, csvname2, quote=TRUE, row.names=FALSE)  
#   print(nrow(newdiffs))
#   print(proj)
#   print(length(unique(newdiffs$devId)))
# }

