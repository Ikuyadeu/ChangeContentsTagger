diffs <- read.csv("csv/miss.csv", sep = ",", header = TRUE, row.names = NULL)

cols <- c("#FF0000", "#00FF00", "#0000FF",
          "#FFFF00", "#FF00FF", "#00FFFF", "#888888", "#FFFFFF", "#FF8800")

nxt.pull <-  5

numerator.names <- c("Comment", "If", "Moved", "NewLine",
                     "L_Renamed", "RenameFile", "L_SpaceOrTab",
                     "L_Symbol", "L_UpperOrLower")
numerator.names2 <- c("Comment     ",
                      "If          ",
                      "Moved       ",
                      "NewLine     ",
                      "Renamed     ",
                      "RenameFile  ",
                      "SpaceOrTab  ",
                      "Symbol      ",
                      "UpperOrLower")
numerator.names <- c("NewLine")
projects <- c("qt/qtbase")
edate <- as.Date("2012-3-1")
diffs$Date <- as.Date(diffs$Date)

for (j in 1:length(projects)){
  proj <- projects[j]
  print(proj)
  diffs2 <- subset(diffs, diffs$project == proj)
  # head(subset(diffs2, diffs2$) n = nxt.pull)
  proj <- gsub("/", "-", proj)
  for (i in 1:length(numerator.names)){
      numerator <- numerator.names[i]
      # boxplot (
      # (1.0 / (diffs2[, paste(numerator, ".miss", sep = "")] + 1))~diffs2[, numerator]
      # , main = numerator.names2[i]
      # , ylim = c(0.0, 1.0), xlim = c(0, 20),
      # cex.axis = 1.25, cex.main = 1.5, cex = 2)
      # print(prop.table(table(diffs2[, paste(numerator, ".miss", sep = "")], diffs2[, numerator]), margin = 2)[2, ])
      # dev.copy2eps(file=paste("/Users/yuki-ud/Documents/Source/ChangeContentsTagger/R/plot/grow/",
      # "second/", numerator.names2[i], ".eps", sep = ""))
      # dev.off()

      plot (
      prop.table(table(diffs2[, paste(numerator, ".miss", sep = "")], diffs2[, numerator]), margin = 2)[2, ]
      , main = numerator.names2[i]
      , ylim = c(0.0, 1.0), xlim = c(0, 50),
      cex.axis = 1.25, cex.main = 1.5, cex = 2)
      # dev.copy2eps(file=paste("/Users/yuki-ud/Documents/Source/ChangeContentsTagger/R/plot/grow/",
      # "second/", numerator.names2[i], ".eps", sep = ""))
      # dev.off()
  }
}
# 0B4zoxduukAbQeFBEU2JBSjRwZ0E