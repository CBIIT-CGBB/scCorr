rm(list=ls());

options(stringsAsFactors = F);

load("../data_sets/dat_nor_Seurat.RData");
ann <- read.table("../data_sets/genes.txt", header=T);
sum(row.names(dat)==ann[,1])==nrow(ann);

clu   <- read.table("../follow_up_20190924/cluster/do_tsne30_2000.txt", header=T);
dat.i <- which(colnames(dat) %in% row.names(clu));
dat0  <- dat[,dat.i];
dat0  <- as.matrix(dat0);
sum(row.names(clu)==colnames(dat0))==nrow(clu);

gene0 <- c("TCF7", "TOX");
gene1 <- c("CISH", "PDCD1", "ENTPD1");

clu.d <- read.table("07merge_cluster.txt", header=T);
clu.u <- unique(clu.d[,4]);

cols <- rainbow(10, alpha=0.8);

pdf("08cluster_corr.pdf", 8,8);
par(mfrow=c(2,2));

out.s <- NULL;
for (g1 in gene0){
  g1.i <- which(ann[,2]==g1);
  for (g2 in gene1){
    g2.i <- which(ann[,2]==g2);
    v1 <- NULL;
    v2 <- NULL;
    for (clu.n in clu.u){
      i.i <- which(clu.d[,4]==clu.n);
      i.n <- row.names(clu.d)[i.i];
      d.i <- which(colnames(dat0) %in% i.n);
      v1  <- c(v1, mean(dat0[g1.i, d.i]));
      v2  <- c(v2, mean(dat0[g2.i, d.i]));
    }
    out  <- summary(glm(v1~v2));
    out2 <- cor(v1, v2);
    main  <- paste0("P value: ", sprintf("%.3E", out$coef[2,4]), "\n", "tvalue: ", round(out$coef[2,3], 3));
    plot(v2, v1, xlab=g2, ylab=g1, pch=19, col=cols[7], main=main);
    abline(lm(v1 ~ v2), col=cols[1], lwd=2);
    out.s <- rbind(out.s, c(g1, g2, out2[1], out$coef[2,3], out$coef[2,4]));
  }
}
dev.off();

p.adjust.M <- p.adjust.methods[c(4,7)];

p.adj   <- sapply(p.adjust.M, function(meth) p.adjust(out.s[,5], meth));
out.p   <- cbind(out.s, p.adj);
out.p   <- out.p[order(as.numeric(out.p[,5])),];
colnames(out.p) <- c("gene1", "gene2", "cc", "tvalue", "P.value", "bonferroni", "fdr")
write.table(out.p, "08cluster_corr.txt", quote=F, sep="\t", row.names=F);
