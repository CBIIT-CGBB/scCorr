rm(list=ls());

options(stringsAsFactors = F);
ct   <- "Bcell";
## gene expression matrix
infd <- paste0("../scCorr_data_sets/ct_", ct, ".RData");
load(infd);
## gene annotation
ann  <- read.table("../scCorr_data_sets/gene4matrix.txt", header=T);
sum(row.names(cdat)==ann[,1])==nrow(ann);
## gene interaction
g.d  <- read.table("../scCorr_data_sets/hsa04024_f.txt", header=T);
## tsne result
ts.f <- paste0("../scCorr_data_sets/tsne/tsne_", ct, ".txt");
ts   <- read.table(ts.f, header=T);
sum(row.names(ts)==colnames(cdat))==nrow(ts);

source("../scCorr_functions/do_region.R");
out.s <- NULL;
for (xy in 1:2){
  rg <- do_region(ts, xy, l=50, m="w")
  for (i in 1:nrow(g.d)){
    g1 <- g.d[i,1];
    g2 <- g.d[i,2];
    v1    <- region2v(rg, cdat, ann, g1);
    v2    <- region2v(rg, cdat, ann, g2);
    v1.v  <- var(v1$v);
    v2.v  <- var(v2$v);
    if (v1.v==0 | v2.v==0){
      next;
    }
    out   <- summary(glm(v1$v~ v2$v));
    t.n   <- paste0("tsne", xy);
    out.s <- rbind(out.s, c(g1, g2, t.n, g.d[i,5], out$coef[2,3], out$coef[2,4]));
  }
}

p.adjust.M <- p.adjust.methods[c(4,5)];

p.adj   <- sapply(p.adjust.M, function(meth) p.adjust(out.s[,6], meth));
out.p   <- cbind(out.s, p.adj);
out.p   <- out.p[order(as.numeric(out.p[,6])),];
colnames(out.p) <- c("gene1", "gene2", "tsne", "interaction", "tvalue", "P.value", "bonferroni", "fdr")
write.table(out.p, "01do_window_w.txt", quote=F, sep="\t", row.names=F);




