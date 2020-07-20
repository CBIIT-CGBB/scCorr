rm(list=ls());

options(stringsAsFactors = F)
library(GCluster);

source("merge_cluster.R")
dat   <- read.table("06do_cluster_all_clu.txt", header=T);
dat   <- dat[,-3];
out1  <- merge_cluster(dat, 15);
out2  <- mgGCluster(dat[,3], l=out1, rename=TRUE);
clu.u <- unique(out2$renamed);
clu.n <- length(clu.u);
out.s <- data.frame(dat, clu.out=out2$renamed);
write.table(out.s, "07merge_cluster.txt", quote=F, sep="\t");

pdf("07merge_cluster.pdf", 6,6);
cols   <- rainbow(clu.n, alpha=0.4);
set.seed(1234);
cols   <- sample(cols);
main   <- paste0("clu.n:", clu.n);
plot(dat[,c(1,2)], pch=19, col=cols[out2$renamed], main=main, cex=0.2);
for (i in clu.u){
  j <- which(as.numeric(out2$renamed)==i);
  x <- mean(as.numeric(dat[j, 1]));
  y <- mean(as.numeric(dat[j, 2]));
  shadowtext(x, y, i, cex=0.4);
}
dev.off();
