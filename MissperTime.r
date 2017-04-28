diffs <- read.csv("./diff.csv", sep = ',', header = TRUE, row.names = NULL)
diffs2 <- read.csv("./date.csv", sep = ',', header = TRUE, row.names = NULL)

thresholds <- c(0, 50, 100)
cols <- c("#FF0000", "#00FF00", "0000FF")

per.contents.denominator <- ""
per.contents.numerators <- c("")
diffs$Date <- as.Date(diffs2$Date)
diffs <- subset(diffs, CHANGED_LINES > 0)

per.lines.denominator <- "ChangeLines"
# diffs$per.lines.numerators <- (diffs, NewLine + If + Comment + L_SpaceOrTab + L_UpperOrLower + L_Symbol + L_Renamed)
diffs$per.lines.numerators <- diffs$NewLine + diffs$If + diffs$Comment + diffs$L_SpaceOrTab + diffs$L_UpperOrLower + diffs$L_Symbol + diffs$L_Renamed
diffs$per.lines.numerators <- diffs$per.lines.numerators / diffs$CHANGED_LINES

write.csv(diffs, "./diff2.csv", row.names = TRUE, quote=TRUE)

# diffs$isFew <- diffs$per.lines.numerators / diffs$ChangeLines
# print(isFew)

# ts <- apply.weekly(xts(diffs$SubDate, diffs$date), median)
# plot.zoo(ts, ylim = c(0, 600), col = cols, plot.type = "single", ylab = "Few Change Num", xlab = "Date")
# legend("topleft", legend = thresholds, fill = cols, cex = 1.0)