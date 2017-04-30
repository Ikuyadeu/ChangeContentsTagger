library(xts)
diffs <- read.csv("./diff2.csv", sep = ',', header = TRUE, row.names = NULL)

cols <- c("#FF0000", "#00FF00", "#0000FF",
          "#FFFF00", "#FF00FF", "#00FFFF", "#888888")

per.contents.denominator <- ""
per.contents.numerators <- c("")
diffs$Date <- as.Date(diffs$Date)
diffs <- subset(diffs, CHANGED_LINES > 0 & PatchNo > 1)

per.lines.denominator <- "ChangeLines"
numerator.names <- c("NewLine", "If", "Comment", "L_SpaceOrTab", "L_UpperOrLower", "L_Symbol", "L_Renamed")

for (i in 1:length(numerator.names)) {
    numerator.name <- numerator.names[i]
    diffs[numerator.name] <- diffs[numerator.name] / diffs$CHANGED_LINES
    bts <- apply.weekly(xts(diffs[numerator.name], diffs$Date), median)
    if (i==1){
        ts <- bts
    } else {
        ts <- na.locf(merge(ts, bts))
    }
}
diffs$per.lines.numerators <- diffs$NewLine + diffs$If + diffs$Comment + diffs$L_SpaceOrTab + diffs$L_UpperOrLower + diffs$L_Symbol + diffs$L_Renamed
bts <- apply.weekly(xts(diffs$per.lines.numerators, diffs$Date), median)
ts <- na.locf(merge(ts, bts))
numerator.names <- append(numerator.names, "ALL")
cols <- append(cols, "#000000")

plot.zoo(ts, ylim = c(0, 0.3), col = cols, plot.type = "single", ylab = "Small Change Per", xlab = "Date")
legend("topleft", legend = numerator.names, fill = cols, cex = 1.0)