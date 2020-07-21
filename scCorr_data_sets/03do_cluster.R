#!/usr/local/apps/R/3.5/3.5.2/bin/Rscript

options(stringsAsFactors = F);
library(GCluster);

argv    <- commandArgs(TRUE);
ct.s    <- argv[1];

inff <- paste0("tsne/tsne_", ct.s, ".txt");
dat  <- read.table(inff, header=T);
clu.o <- GCluster(dat, k=150);

clu.i <- clu.o$membership;

out.c <- data.frame(dat, cluster=clu.i);
outf  <- paste0("cluster/clu_", ct.s, ".txt"); 
write.table(out.c, outf, quote=F, sep="\t");
