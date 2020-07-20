#!/usr/local/apps/R/3.5/3.5.2/bin/Rscript

options(stringsAsFactors = F);
library(GCluster);

load("../data_sets/dat_nor_Seurat.RData");
ann <- read.table("../data_sets/genes.txt", header=T);
sum(row.names(dat)==ann[,1])==nrow(ann);

gene0 <- c("TCF7", "TOX");
gene1 <- c("CISH", "PDCD1", "ENTPD1");

clu   <- read.table("../follow_up_20190924/cluster/do_tsne30_2000.txt", header=T);
dat.i <- which(colnames(dat) %in% row.names(clu));
dat0  <- dat[,dat.i];
sum(row.names(clu)==colnames(dat0))==nrow(clu);
clu.o <- GCluster(clu, k=200);

clu.i <- clu.o$membership;

out.c <- data.frame(clu, cluster=clu.i);
write.table(out.c, "06do_cluster_all_clu.txt", quote=F, sep="\t");
