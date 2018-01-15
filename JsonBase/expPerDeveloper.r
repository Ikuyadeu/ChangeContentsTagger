diffs <- read.csv("developers.csv", sep = ",",
                                    header = TRUE,
                                    row.names = NULL,
                                    check.names = FALSE)

developers <- subset(diffs, diffs$exp > 30)$ch_author_account_id


account_id <- unique(diffs$ch_author_account_id)

diffs <- diffs[!duplicated(diffs$ch_author_account_id, fromLast = TRUE), ]


plot.new()
i <- 1

missies <- data.frame()
a <- table(diffs$space_num, diffs$exp)
b <- prop.table(a)

corrplot(a, is.corr = FALSE, cl.lim = c(0, 40), col = terrain.colors(200))
plot(a)

for (ai in account_id) {
    account_diffs <- subset(diffs, diffs$ch_author_account_id == ai)
    # missies[ai] <- account_diffs$space_num / account_diffs$exp
    missies <- append(missies, account_diffs$space_num / account_diffs$exp)
    par(new = T)
    plot(account_diffs$exp, account_diffs$space_num / account_diffs$exp,
         add = TRUE,
         type = "l",
         xlim = c(0, 50),
         ylim = c(0, 1.0),
         col = i)
    i <- i + 1
}
