# First use
data("toy")
plot(toy)

set.seed(1986)
a <- archetypes(toy, 3, verbose = TRUE)
a
parameters(a)

xyplot(a, toy, chull = chull(toy))
xyplot(a, toy, adata.show = TRUE)

set.seed(1986)
a4 <- stepArchetypes(data = toy, k = 3, verbose = FALSE, nrep = 4)
a4
summary(a4)
res(as)
xyplot(a4, toy)
bestModel(a4)
set.seed(1986)
as <- stepArchetypes(data = toy, k = 1:10, verbose = FALSE, nrep = 4)
rss(as)


gas <- stepArchetypes(data = toy, k = 1:10, 
family = archetypesFamily("ginv"), verbose = FALSE, nrep = 4)