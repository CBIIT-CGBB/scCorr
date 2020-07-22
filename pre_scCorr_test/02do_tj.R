rm(list=ls());

options(stringsAsFactors = F);
library(GCluster);

ct   <- "Bcell";
## gene expression matrix
infd <- paste0("../scCorr_data_sets/ct_", ct, ".RData");
load(infd);
## gene annotation
ann  <- read.table("../scCorr_data_sets/gene4matrix.txt", header=T);
sum(row.names(cdat)==ann[,1])==nrow(ann);
## gene interaction data
g.d  <- read.table("../scCorr_data_sets/hsa04024_f.txt", header=T);
## tsne result
ts.f <- paste0("../scCorr_data_sets/tsne/tsne_", ct, ".txt");
ts   <- read.table(ts.f, header=T);
sum(row.names(ts)==colnames(cdat))==nrow(ts);

outf  <- "02do_tj.txt";
source("../scCorr_functions/do_tj.R")

out.s <- NULL;
for (c.i in 1:2){
  inff <- paste0("../scCorr_data_sets/tj/", ct, "_", c.i, ".RData");
  load(inff);
  for (i in 1:nrow(g.d)){
    g1    <- g.d[i,1];
    g2    <- g.d[i,2];
    ov1   <- do_tj(ov3$out2$node, ov3$out2$level, cdat, g1);
    ov2   <- do_tj(ov3$out2$node, ov3$out2$level, cdat, g2);
    n1.i  <- which(ov1$n==1);
    n2.i  <- which(ov2$n==1);
    n0.i  <- unique(c(n1.i, n2.i));
    v1    <- ov1$v[-n0.i];
    v2    <- ov2$v[-n0.i];
    v1.v  <- var(v1);
    v2.v  <- var(v2);
    if (v1.v==0 | v2.v==0){
      next;
    }
    out   <- summary(glm(v1~v2));
    t.s   <- paste0("tsne", c.i);
    out.s <- rbind(out.s, c(g1, g2, t.s, g.d[i,5], out$coef[2,3], out$coef[2,4]))
  }
}

p.adjust.M <- p.adjust.methods[c(4,7)];

p.adj   <- sapply(p.adjust.M, function(meth) p.adjust(out.s[,6], meth));
out.p   <- cbind(out.s, p.adj);
out.p   <- out.p[order(as.numeric(out.p[,6])),];
colnames(out.p) <- c("gene1", "gene2", "tsne", "interaction", "tvalue", "P.value", "bonferroni", "fdr")
write.table(out.p, outf, quote=F, sep="\t", row.names=F);
