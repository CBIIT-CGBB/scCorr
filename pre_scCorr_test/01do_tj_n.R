rm(list=ls());

options(stringsAsFactors = F);
library(GCluster);

load("../data_sets/dat_nor_Seurat.RData");
ann <- read.table("../data_sets/genes.txt", header=T);
sum(row.names(dat)==ann[,1])==nrow(ann);

gene0 <- c("TCF7", "TOX");
gene1 <- c("CISH", "PDCD1", "ENTPD1");

sig.d <- read.table("../follow_up_20200709/13do_tsne_gene_ind_sig_split_n2.txt", head=T); 
sig.t <- gsub("tsne", "", sig.d[,3]);
sig.t <- as.numeric(sig.t);

col3  <- rainbow(10, alpha=0.2);

outf  <- "01do_tj_n2.txt";
pdf("01do_tj_n2.pdf", 8, 8);
par(mfrow=c(2, 2));
source("do_tj.R")

out.s <- NULL;
for (i in 1:nrow(sig.d)){
  print(i);
  i.s <- sig.d[i,1];
  t.s <- sig.d[i,4];
  t.n <- sig.d[i,3];
  g1  <- sig.d[i,2];
  g2  <- sig.d[i,11];
  print(c(i.s, t.s));
  cluf  <- paste0("../follow_up_20200206/tsne/do_tsne_", i.s, "_", t.s, ".txt");
  clu   <- read.table(cluf, header=T);
  if (sig.t[i]==1){
    c1.i <- which.min(clu[,1]);
    c2.i <- which.max(clu[,1]);
  } else {
    c1.i <- which.min(clu[,2]);
    c2.i <- which.max(clu[,2]);
  }
  out1  <- tjGCluster(clu, from=c1.i, to=c2.i);
  out2  <- tjGCluster2(clu, from=c1.i, to=c2.i, cutoff=10000);
  ov1   <- do_tj(out2$node, out2$level, dat, g1);
  ov2   <- do_tj(out2$node, out2$level, dat, g2);
  n1.i  <- which(ov1$n==1);
  n2.i  <- which(ov2$n==1);
  n0.i  <- unique(c(n1.i, n2.i));
  out   <- summary(glm(ov1$v[-n0.i]~ov2$v[-n0.i]));
  out.s <- rbind(out.s, c(i.s, t.s, t.n, sig.d[i,2], sig.d[i,11], out$coef[2,3], out$coef[2,4]))
  m.j   <- match(out2$node, row.names(clu));

  subs  <- paste0(i.s, " ", t.s, " ", t.n);
  main  <- paste0(g1, "\n", subs);
  plot(clu[,1:2], pch=19, col=col3[7], xlab="tSNE 1", ylab="tSNE 2", main=main, cex=0.5);
  col1   <- color.scale(ov1$v, c(0,0,0), c(0, 0.5, 1), c(1,1,1), alpha=0.8, color.spec="hsv");
  segments(out1$coord[,1], out1$coord[,2], out1$coord[,3], out1$coord[,4], col="white", lwd=3)
  segments(out1$coord[,1], out1$coord[,2], out1$coord[,3], out1$coord[,4], col="red");
  points(clu[m.j, c(1,2)], pch=19, col="white", cex=log2(ov1$n)/2.8);
  points(clu[m.j, c(1,2)], pch=19, col=col1, cex=log2(ov1$n)/3);
  
  main  <- paste0(g2, "\n", subs);
  plot(clu[,1:2], pch=19, col=col3[7], xlab="tSNE 1", ylab="tSNE 2", main=main, cex=0.5);
  col2   <- color.scale(ov2$v, c(0,0,0), c(0, 0.5, 1), c(1,1,1), alpha=0.8, color.spec="hsv");
  segments(out1$coord[,1], out1$coord[,2], out1$coord[,3], out1$coord[,4], col="white", lwd=3)
  segments(out1$coord[,1], out1$coord[,2], out1$coord[,3], out1$coord[,4], col="red");
  points(clu[m.j, c(1,2)], pch=19, col="white", cex=log2(ov2$n)/2.8);
  points(clu[m.j, c(1,2)], pch=19, col=col2, cex=log2(ov2$n)/3);

}
dev.off();

p.adjust.M <- p.adjust.methods[c(4,7)];

p.adj   <- sapply(p.adjust.M, function(meth) p.adjust(out.s[,7], meth));
out.p   <- cbind(out.s, p.adj);
out.p   <- out.p[order(as.numeric(out.p[,7])),];
colnames(out.p) <- c("sample", "tsne.pr", "tsne.dim", "gene1", "gene2", "tvalue", "P.value", "bonferroni", "fdr")
write.table(out.p, outf, quote=F, sep="\t", row.names=F);
