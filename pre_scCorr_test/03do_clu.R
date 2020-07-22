rm(list=ls());

options(stringsAsFactors = F);
library(GCluster);

ct   <- "Bcell";
## gene expression matrix
infd  <- paste0("../scCorr_data_sets/ct_", ct, ".RData");
load(infd);
## gene annotation
ann   <- read.table("../scCorr_data_sets/gene4matrix.txt", header=T);
sum(row.names(cdat)==ann[,1])==nrow(ann);
## gene interaction
g.d   <- read.table("../scCorr_data_sets/hsa04024_f.txt", header=T);
## cluster result
clu.f <- paste0("../scCorr_data_sets/cluster/clu_", ct, ".txt");
clu   <- read.table(clu.f, header=T);
sum(row.names(clu)==colnames(cdat))==nrow(clu);

outf  <- "03do_clu.txt";
source("../scCorr_functions/merge_cluster.R")
length(unique(clu[,3]));
clu.o <- merge_cluster(clu, cutoff=5);
out2  <- mgGCluster(clu[,3], l=clu.o, rename=TRUE);
clu.f <- out2$renamed;
clu.u <- unique(out2$renamed);
clu.n <- length(clu.u);

cdat  <- as.matrix(cdat);
out.s <- NULL;
for (i in 1:nrow(g.d)){
  g1    <- g.d[i,1];
  g2    <- g.d[i,2];
  g1.i  <- which(ann[,2]==g1)[1];
  g2.i  <- which(ann[,2]==g2)[1];
  v1    <- NULL;
  v2    <- NULL;
  for (c.n in clu.u){
    j     <- which(clu.f==c.n);
    tmp1  <- mean(as.numeric(cdat[g1.i, j]));
    tmp2  <- mean(as.numeric(cdat[g2.i, j]));
    v1 <- c(v1, tmp1);
    v2 <- c(v2, tmp2);
  }
  v1.v <- var(v1);
  v2.v <- var(v2);
  if (v1.v==0 | v2.v==0){
    next;
  }
  out <- summary(glm(v1~v2));
  out.s <- rbind(out.s, c(g1, g2, g.d[i,5], out$coef[2,3], out$coef[2,4]));
}
p.adjust.M <- p.adjust.methods[c(4,7)];

p.adj   <- sapply(p.adjust.M, function(meth) p.adjust(out.s[,5], meth));
out.p   <- cbind(out.s, p.adj);
out.p   <- out.p[order(as.numeric(out.p[,5])),];
colnames(out.p) <- c("gene1", "gene2", "interaction", "tvalue", "P.value", "bonferroni", "fdr")
write.table(out.p, outf, quote=F, sep="\t", row.names=F);
