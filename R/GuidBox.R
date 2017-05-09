diffs <- read.csv("csv/devs22.csv", sep = ",", header = TRUE, row.names = NULL)

maxexp <- 50
diffs <- subset(diffs, exp < maxexp)
diffs$Date <- as.Date(diffs$Date)

event.date <- as.Date("2012-3-1")

numerator.names <- c("NewLine", "If", "Comment",
                     "L_SpaceOrTab", "L_UpperOrLower", "L_Symbol",
                     "L_Renamed", "Moved", "RenameFile")
numerator.names <- c("NewLine")
numerator.names2 <- c("NewLine", "If", "Comment",
                     "SpaceOrTab", "UpperOrLower", "Symbol",
                     "Renamed", "Moved", "RenameFile")
cols <- c("#FF0000", "#00FF00", "#0000FF",
          "#FFFF00", "#FF00FF", "#00FFFF", "#888888", "#FFFFFF", "#FF8800")
projects <- c("qt/qtbase", "qt-creator/qt-creator", "qt/qtdeclarative")
# projects <- c("qt/qtbase")


for (j in 1:length(projects)){
        proj <- projects[j]
        diffs2 <- subset(diffs, diffs$project == proj)
        proj <- gsub("/", "-", proj)

        before.id <- unique(subset(diffs2, diffs2$Date < event.date)$devId)
        after.id <- unique(subset(diffs2, diffs2$Date >= event.date)$devId)

        before.dev <- subset(diffs2, diffs2$devId %in% setdiff(before.id, after.id))
        after.dev <- subset(diffs2, diffs2$devId %in% setdiff(after.id, before.id))
        both.dev <- subset(diffs2, diffs2$devId %in% intersect(before.id, after.id))
        before.both.dev <- subset(both.dev, both.dev$Date < event.date)
        after.both.dev <- subset(both.dev, both.dev$Date >= event.date)

        before.dev <- before.dev[order(before.dev$Date, decreasing=T),]
        after.dev <- after.dev[order(after.dev$Date, decreasing=T),]
        before.both.dev <- before.both.dev[order(before.both.dev$Date, decreasing=T),]
        after.both.dev <- after.both.dev[order(after.both.dev$Date, decreasing=T),]

        before.dev <- before.dev[!duplicated(before.dev$devId),]
        after.dev <- after.dev[!duplicated(after.dev$devId),]
        before.both.dev <- before.both.dev[!duplicated(before.both.dev$devId),]
        after.both.dev <- after.both.dev[!duplicated(after.both.dev$devId),]

        before.both.dev <- before.both.dev[order(before.both.dev$devId, decreasing=T),]
        after.both.dev <- after.both.dev[order(after.both.dev$devId, decreasing=T),]
        
        after.both.dev$exp <- after.both.dev$exp - before.both.dev$exp 
        # print(both.diffs)

        for (i in 1:length(numerator.names)) {
                numerator.name <- numerator.names[i]
                nn2 <- numerator.names2[i]
                both.b <- before.both.dev[numerator.name] / before.both.dev$exp
                both.a <- (after.both.dev[numerator.name] - before.both.dev[numerator.name]) / after.both.dev$exp
                b <- before.dev[numerator.name] / before.dev$exp
                a <- after.dev[numerator.name] / after.dev$exp
                boxplot(c(both.b, both.a, b, a)
                        ,names=c("both.before", "both.after", "only.before", "only.after")
                        ,ylim = c(0.0, 1.0),
                        ylab = nn2, col = cols[i],cex.lab=1.2,cex.axis=2)
                dev.copy2eps(file=paste("R/plot/",proj,"/", nn2, "_box.eps", sep = ""))
      
                dev.off()
        }
}