rm(list=ls());

options(stringsAsFactors = F);
library(GCluster);
source("../scCorr_functions/merge_cluster.R");

n <- 10;
out.s <- NULL;
for (i in 2:81){
  print(n)
  inff  <- paste0("../scCorr_data_sets/cluster/clu_Bcell_", n, ".txt");
  if (!file.exists(inff)){
    n <- i * 10;
    next;
  }
  dat   <- read.table(inff, header=T);
  c.n   <- length(unique(dat[,3]));
  c.t   <- table(dat[,3]);
  c.i   <- which(c.t <= 5);
  o.n   <- length(c.i);
  if (length(c.i) > 0 & n != 30){
    out  <- merge_cluster(dat);
    out2 <- mgGCluster(dat[,3], out, rename=T);
    o.m  <- length(unique(out2$renamed));
  } else {
    o.m  <- c.n;
  }
  out.s <- rbind(out.s, c(n, c.n, o.n, o.m));
  n <- i * 10
}

colnames(out.s) <- c("clu.num.inp", "clu.num.out", "<=5.num", "final.clu.num");
write.table(out.s, "03do_cluster_sum.txt", quote=F, sep="\t", row.names=F);

