diffs <- read.csv("/Users/yuki-ud/Documents/Source/ChangeContentsTagger/csv/devs2.csv", sep = ',', header = TRUE, row.names = NULL)

maxexp <- 100

diffs <- subset(diffs, exp < maxexp)
plot(table(diffs$exp), ylab = "Developer Num", xlab = "Exp")