diffs <- read.csv("developers.csv", header = TRUE, row.names = NULL, check.names = FALSE)


boxplot(diffs$exp)

mcor <- cor(mtcars)
round(mcor, digits=2)

library(corrplot)
corrplot(mcor)

diffs <- read.csv("developers.csv", sep = ",", header = TRUE, row.names = NULL, check.names = FALSE)

account_id <- unique(diffs$ch_author_account_id)

plot.new()
i <- 1
a <- table(diffs$exp, diffs$space_num)
for (ai in account_id) {
    account_diffs <- subset(diffs, diffs$ch_author_account_id == ai)
    par(new=T)
    plot(account_diffs$exp, account_diffs$space_num, add=TRUE, type="l", xlim=c(0,30), ylim=c(0,30), col=i)
    i <- i + 1
}