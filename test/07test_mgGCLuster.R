rm(list=ls());

library(scCorr);
## cluster matrix
cluf   <- "https://github.com/CBIIT-CGBB/scCorr/raw/master/data/01/03clust_table.txt";
clu    <- read.table(cluf, header=T, sep="\t");

## get one cluster result 
out    <- mgGCluster(clu[,23], list(c(9, 10), c(19, 20)), rename=F);
table(out$merged)
table(clu[,23]);
