data("toy")

library("archetypes")
#rawData <- read.csv("Documents/jisedai/hiruma/preprocessing/test_output/test/script/output_final_otu_map.txt",sep=",",header=T)
rawData <- read.csv("Documents/jisedai/hiruma/preprocessing/test_output/otus_2/script/output_final_otu_map_removedCleanupLine.txt",sep=",",header=T)
rawData$id <- factor(rawData$id, ordered = FALSE)
data <- rawData[,c(-1)]

for (i in 1:ncol(data)) {
  data[,i] = data[,i]/max(data[,i])
}

set.seed(1981)
as <- stepArchetypes(data, k=1:10, verbose=FALSE, nrep=3)
screeplot(as)
a3 <- bestModel(as[[3]])
t(parameters(a3))
barplot(a3,data, percentiles=TRUE)

pcplot(a3, data, data.col = as.numeric(skel$Gender))


library(vcd)
#ternaryplot(coef(a3, 'alphas'))
simplexplot(a3)

result_raw <- as.table(coef(a3,'alphas'))
result <- cbind(rawData[,1],result_raw)

write.csv(result,"~/Desktop/result_10.csv",quote=F,row.names=T,fileEncoding="UTF-8", eol="\n")


######################
libray(sna)
snaData <-read.csv("Documents/jisedai/hiruma/preprocessing/test_output/otus/script/sna.csv",sep=",",header=F)
gplot(snaData, g=1,displaylabels = FALSE)

######################

as <- stepArchetypes(sampleData, k=1:10, verbose=FALSE, nrep=3)
screeplot(as)
a3 <- bestModel(as[[4]])
t(parameters(a3))
barplot(a3,sampleData, percentiles=TRUE)

pcplot(a3, sampleData, data.col = as.numeric(skel$Gender))

#???????????????
library(vcd)
#ternaryplot(coef(a3, 'alphas'))
simplexplot(a3)
