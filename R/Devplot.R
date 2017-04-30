diffs <- read.csv("./devs.csv", sep = ',', header = TRUE, row.names = NULL)

cols <- c("#FF0000", "#00FF00", "#0000FF",
          "#FFFF00", "#FF00FF", "#00FFFF", "#888888")

maxexp <- 10
# maxexp <- max(diffs$exp)
diffs <- subset(diffs, CHANGED_LINES > 0 & PatchNo > 1 & exp < maxexp)

numerator.names <- c("NewLine", "If", "Comment", 
                     "L_SpaceOrTab", "L_UpperOrLower", "L_Symbol", "L_Renamed")

for (i in 1:length(numerator.names)) {
    numerator.name <- numerator.names[i]
    # print(length(diffs$exp))
    # print(length(diffs[,numerator.name]))
    # plot(x = diffs$exp, y = diffs[,numerator.name], 
    #      xlim = c(0.0, maxexp), ylim = c(0.0, maxexp),
    #      xlab = "experience", ylab = "Miss", col = cols[i])
    # boxplot(NewLine~exp, data = diffs, 
    #      xlim = c(0.0, maxexp), ylim = c(0.0, maxexp),
    #      xlab = "experience", ylab = "Miss")
    pdf(paste("R/plot/", numerator.name, ".pdf", sep = ""))
    boxplot(diffs[,numerator.name]~diffs$exp,
            xlim = c(0.0, maxexp), ylim = c(0.0, maxexp),
            xlab = "experience", ylab = numerator.name, col = cols[i])
    dev.off()
}
# legend("topleft", legend = numerator.names, fill = cols, cex = 1.0)