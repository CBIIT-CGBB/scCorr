rm(list=ls());

library(scCorr);

## get data
## 5 clusters of CD4 T cells
ct.c   <- c(6:10); 
## tsne result/output
tsnef  <- "https://github.com/CBIIT-CGBB/scCorr/raw/master/data/01/do_tsne30_2000.txt";
tsne   <- read.table(tsnef, header=T);

## cluster matrix
cluf   <- "https://github.com/CBIIT-CGBB/scCorr/raw/master/data/01/03clust_table.txt";
clu    <- read.table(cluf, header=T, sep="\t");
## check row.names
sum(row.names(tsne)==row.names(clu))==nrow(clu);
## sample index of CD4 T cells in the cluster matrix
s.i    <- which(clu[,23] %in% ct.c);
## some single cells of CD4 T cells 
dat    <- tsne[s.i,];

cols   <- rainbow(10, alpha=0.8);

angle  <- seq(0, 180, length.out = 20);
for (i in 1:length(angle)){
  pdff <- paste0("out/out", i, ".pdf");
  pdf(pdff, 6, 6);
  par(mar=c(2,2,2,2))
  out <- r_c(dat, degree=360-angle[i]);
  plot(out, xlab="tSNE 1", ylab="tSNE 2", pch=19, col=cols[7], cex=2);
  dev.off();
}


