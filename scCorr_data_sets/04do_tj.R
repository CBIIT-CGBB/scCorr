#!/usr/local/apps/R/3.5/3.5.2/bin/Rscript --slave
argv    <- commandArgs(TRUE);
ct.s    <- argv[1];
c.i     <- as.numeric(argv[2]);

options(stringsAsFactors = F);
library(GCluster);

inff  <- paste0("tsne/tsne_", ct.s, ".txt");
clu   <- read.table(inff, header=T);

outf2 <- paste0("tj/", ct.s, "_", c.i, ".RData");
source("do_tj.R")

out.s <- NULL;
if (c.i==1){
  c1.i <- which.min(clu[,1]);
  c2.i <- which.max(clu[,1]);
} else {
  c1.i <- which.min(clu[,2]);
  c2.i <- which.max(clu[,2]);
}
out1  <- tjGCluster(clu, from=c1.i, to=c2.i);
out2  <- tjGCluster2(clu, from=c1.i, to=c2.i, cutoff=10000);
ov3   <- list(out1=out1, out2=out2);
save(ov3, file=outf2);
