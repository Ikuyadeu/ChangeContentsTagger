
diffs <- read.csv("csv/devs22.csv", sep = ",", header = TRUE, row.names = NULL)

maxexp <- 50
diffs <- subset(diffs, exp < maxexp)
diffs$Date <- as.Date(diffs$Date)

event.date <- as.Date("2012-3-1")

numerator.names <- c("Comment", "If", "Moved","NewLine",
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
cols <- c("#FF0000", "#00FF00", "#0000FF",
          "#FFFF00", "#FF00FF", "#00FFFF", "#888888", "#FFFFFF", "#FF8800")
projects <- c("qt/qtbase", "qt-creator/qt-creator")
projects <- c("qt/qtbase")
projects <- c("qt-creator/qt-creator")
both.b <- c(x <- as.list(NULL) , x <- as.list(NULL))
both.a <- c(x <- as.list(NULL) , x <- as.list(NULL))
a <- c(c() , c())
b <- c(c() , c())

cols <- c("#FF0000", "#00FF00", "#0000FF", "#FFFF00")
leg <- c("before:common", "after:common", "before:unit", "after:unit")
pr <- c(c(), c())
for (i in 1:length(numerator.names)) {
        numerator.name <- numerator.names[i]
        for (j in 1:length(projects)) {
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

                before.both.dev <- before.both.dev[order(before.both.dev$devId),]
                after.both.dev <- after.both.dev[order(after.both.dev$devId),]
                
                after.both.dev$exp <- after.both.dev$exp - before.both.dev$exp 

                bb <- unlist(before.both.dev[numerator.name]) / before.both.dev$exp
                ab <- unlist(after.both.dev[numerator.name] - before.both.dev[numerator.name]) / after.both.dev$exp
                long <- wilcox.test(unlist(before.both.dev[numerator.name]) / before.both.dev$exp, 
                unlist(after.both.dev[numerator.name]) / after.both.dev$exp)$p.value
                lb <- ifelse(long<0.05, "\verb|<| 0.05" , round(long, digits = 2))
                # print(summary(bb)[["Median"]])
                # print(bb[,1])
                # print(paste(median(bb[,1]), median(ab[,1]), l,sep = " & "))

                # print("short")
                bs <- unlist(before.dev[numerator.name]) / before.dev$exp
                as <- unlist(after.dev[numerator.name]) / after.dev$exp
                short <- wilcox.test(bs, as)$p.value
                ls <- ifelse(short<0.05, "\verb|<| 0.05" , round(short, digits = 2))
                # print(head(bb))
                print(paste(numerator.names2[i], round(median(bb), digits = 2), round(median(ab), digits = 2), lb , round(median(bs), digits = 2), round(median(as), digits = 2), paste(ls, "\\", sep = " ") ,sep =" & "))
        }
        # print("       ")
        # boxplot(c(both.b[1], both.a[1], b[1], a[1], both.b[2], both.a[2], b[2], a[2])
        #         ,xaxt="n"
        #         ,xlab=paste(projects[1], projects[2], sep= paste(rep(" ", 40), sep = "", collapse = ""))
        #         ,ylim = c(0.0, 1.0),
        #         main = nn2, col = cols, cex.lab=1.2, cex.axis=2)
        
        # dev.copy2eps(file=paste("R/plot/second/", nn2, ".eps", sep = ""))

        # dev.off()
}
# for (j in 1:length(projects)) {
#         print(pr[j])
# }