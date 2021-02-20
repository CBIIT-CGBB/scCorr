rm(list=ls());

options(stringsAsFactors = F);
library(scCorr);

scale.v <- function(v, v.start=v.start, v.end=v.end){
  v.start + (v - min(v)) * (v.end-v.start)/(max(v) - min(v));
}

dat  <- read.table("../data/01/do_tsne30_2000.txt");
## number of cluster
k     <- 50;
## scale region is from v1 to v2
v2    <- 300;
v1    <- -1 * s.v2;
c1    <- scale.v(dat[,1], v1, v2);
c2    <- scale.v(dat[,2], v1, v2);
dat2  <- data.frame(v1=c1, v2=c2);

## do GCluster
clu.o <- GCluster(dat2, k=k);

clu.i <- clu.o$membership;
out.c <- data.frame(dat, cluster=clu.i);
outf  <- paste0("clu_", k, ".txt");
write.table(out.c, outf, quote=F, sep="\t");
