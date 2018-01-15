diffs <- read.csv("developers.csv", sep = ",", header = TRUE, row.names = NULL, check.names = FALSE)



account_id <- unique(diffs$ch_author_account_id)

plot.new()
i <- 1
for (ai in account_id) {
    account_diffs <- subset(diffs, diffs$ch_author_account_id == ai)
    par(new=T)
    plot(account_diffs$exp, account_diffs$space_num, add=TRUE, type="l", xlim=c(0,30), ylim=c(0,30), col=i)
    i <- i + 1
}


diffs <- diffs[!duplicated(diffs$ch_author_account_id, fromLast = TRUE),]
boxplot(diffs$exp, ylim = c(0, 300))



write.csv(diffs, file = "lastDeveloper.csv", append = FALSE, sep = ",", check.names = FALSE)

for (change_metrics in change_metricses) {
    miss_devs <- c()
    miss_nums <- c()
    for (i in 0:20){
        new_diffs <- subset(diffs, diffs[,paste(change_metrics, "_num", sep = "")] > i)
        miss_dev <- nrow(new_diffs)
        miss_devs <- append(miss_devs, miss_dev)
        if (miss_dev > 0) {
           miss_nums <- append(miss_nums, sum(new_diffs[change_metrics] == "True") / miss_dev)
        } else {
           miss_nums <- append(miss_nums, 0)
        }
        # print()
        # print(sum(new_diffs[change_metrics] == "True"))
        # print(sum(diffs[, change_metrics] == "True"))
    }
    print(change_metrics)

    # ミス数 / 経験
    plot(diffs$exp, diffs[,paste(change_metrics, "_num", sep = "")], xlim = c(0, 20), ylim = c(0, 1))
    dev.copy2eps(file=paste("/Users/yuki-ud/Documents/DeveloperGrownPlot",
    "/ExpPerMissNum/", change_metrics, ".eps", sep = ""))
    # ミス率 / ミス数(その数だけミスした人のうち何人がもう一度ミスするか)
    plot(0:20, miss_nums, ylim = c(0, 1.0))
    dev.copy2eps(file=paste("/Users/yuki-ud/Documents/DeveloperGrownPlot",
    "/MissNumPerPerMiss/", change_metrics, ".eps", sep = ""))
    # ミス数 / 人数
    plot(0:20, miss_devs)
    dev.copy2eps(file=paste("/Users/yuki-ud/Documents/DeveloperGrownPlot",
    "/MissNumPerDeveloperNum/", change_metrics, ".eps", sep = ""))


    # plot(diffs$exp, diffs[,paste(change_metrics, "_num", sep = "")] /  diffs$exp, ylim = c(0, 1))
    # print(paste(change_metrics, "_num", sep = ""))
}