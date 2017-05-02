library(xts)
diffs <- read.csv("csv/devs3.csv", sep = ',', header = TRUE, row.names = NULL)

cols <- c("#FF0000", "#00FF00", "#0000FF",
          "#FFFF00", "#FF00FF", "#00FFFF", "#888888")

diffs$Date <- as.Date(diffs$Date)

numerator.names <- c("NewLine", "If", "Comment", "L_SpaceOrTab", "L_UpperOrLower", "L_Symbol", "L_Renamed")

for (i in 1:length(numerator.names)) {
    numerator.name <- numerator.names[i]
    bts <- apply.quarterly(xts(diffs[,numerator.name], diffs$Date), mean)
    if (i==1){
        ts <- bts
    } else {
        ts <- na.locf(merge(ts, bts))
    }
}
#diffs$per.lines.numerators <- diffs$NewLine + diffs$If + diffs$Comment + diffs$L_SpaceOrTab + diffs$L_UpperOrLower + diffs$L_Symbol + diffs$L_Renamed
#bts <- apply.quarterly(xts(diffs$per.lines.numerators, diffs$Date), mean)
#ts <- na.locf(merge(ts, bts))
#numerator.names <- append(numerator.names, "ALL")
#cols <- append(cols, "#000000")

plot.zoo(ts, ylim = c(0, 1.0), col = cols, plot.type = "single", ylab = "Small Change Per", xlab = "Date")
legend("topright", legend = numerator.names, fill = cols, cex = 1.0)