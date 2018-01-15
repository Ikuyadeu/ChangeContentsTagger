diffs <- read.csv("csv/devs22.csv", sep = ",", header = TRUE, row.names = NULL)

maxexp <- 50
diffs <- subset(diffs, exp < maxexp)
diffs$Date <- as.Date(diffs$Date)

event.date <- as.Date("2012-3-1")

numerator.names <- c("NewLine",
                     "L_SpaceOrTab",
                     "L_Symbol",
                     "L_Renamed")
numerator.names2 <- c("NewLine",
                     "SpaceOrTab",
                     "Symbol",
                     "Renamed")

projects <- c("qt/qtbase", "qt-creator/qt-creator")

both.b <- c(c() , c())
both.a <- c(c() , c())
a <- c(c() , c())
b <- c(c() , c())

cols <- c("#FF0000", "#00FF00", "#0000FF", "#FFFF00")
leg <- c("before:common", "after:common", "before:unit", "after:unit")
        par(mfcol = c(1, 5))
proj <- "qt/qtbase"
diffs2 <- subset(diffs, diffs$project == proj)
proj <- gsub("/", "-", proj)

before.id <- unique(subset(diffs2, diffs2$Date < event.date)$devId)
after.id <- unique(subset(diffs2, diffs2$Date >= event.date)$devId)

before.dev <- subset(diffs2, diffs2$devId %in% setdiff(before.id, after.id))
after.dev <- subset(diffs2, diffs2$devId %in% setdiff(after.id, before.id))
both.dev <- subset(diffs2, diffs2$devId %in% intersect(before.id, after.id))
before.both.dev <- subset(both.dev, both.dev$Date < event.date)
after.both.dev <- subset(both.dev, both.dev$Date >= event.date)

before.dev <- before.dev[order(before.dev$Date, decreasing = T), ]
after.dev <- after.dev[order(after.dev$Date, decreasing = T), ]
before.both.dev <- before.both.dev[order(before.both.dev$Date, decreasing = T), ]
after.both.dev <- after.both.dev[order(after.both.dev$Date, decreasing = T), ]

before.dev <- before.dev[!duplicated(before.dev$devId),]
after.dev <- after.dev[!duplicated(after.dev$devId),]
before.both.dev <- before.both.dev[!duplicated(before.both.dev$devId),]
after.both.dev <- after.both.dev[!duplicated(after.both.dev$devId),]

before.both.dev <- before.both.dev[order(before.both.dev$devId),]
after.both.dev <- after.both.dev[order(after.both.dev$devId),]

after.both.dev$exp <- after.both.dev$exp - before.both.dev$exp 

plane.numerators <- c()
both.numerators <- c()
for (i in 1:length(numerator.names)) {
        numerator.name <- numerator.names[i]
        print(numerator.name)

        nn2 <- numerator.names2[i]
        both.b <- before.both.dev[numerator.name] / before.both.dev$exp
        both.a <- (after.both.dev[numerator.name] - before.both.dev[numerator.name]) / after.both.dev$exp
        b <- before.dev[numerator.name] / before.dev$exp
        a <- after.dev[numerator.name] / after.dev$exp
        numerators <- c(numerators, median(both.b), median(both.a))
}

boxplot(c(both.b, both.a)
        ,main=numerator.names2[i]
        ,names= c("O", "N", "OO", "ON")
        ,ylim = c(0.0, 1.0), cex.axis=1.25, cex.main=1.5, cex=2)
# dev.copy2eps(file=paste("/Users/yuki-ud/Documents/Paper/OSSresearch-SuperTeam/Review/Domestic/SES2017_Ueda/draft/fig/", "hello2.eps", sep = ""))
# dev.off()