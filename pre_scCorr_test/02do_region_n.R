rm(list=ls());

options(stringsAsFactors = F);

load("../data_sets/dat_nor_Seurat.RData");
ann <- read.table("../data_sets/genes.txt", header=T);
sum(row.names(dat)==ann[,1])==nrow(ann);

gene0 <- c("TCF7", "TOX");
gene1 <- c("CISH", "PDCD1", "ENTPD1");

sigd  <- read.table("../follow_up_20200709/13do_tsne_gene_ind_sig_split_n2.txt", head=T); 
outf  <- "02do_region_n2.txt";
sigd[,3] <- gsub("tsne", "", sigd[,3])

source("do_region.R");
out.s <- NULL;
for (i in 1:nrow(sigd)){
  i.s <- sigd[i, 1];
  t.s <- sigd[i, 4];
  t.n <- paste0("tsne", sigd[i,3])
  print(c(i.s, t.s));
  cluf  <- paste0("../follow_up_20200206/tsne/do_tsne_", i.s, "_", t.s, ".txt");
  clu   <- read.table(cluf, header=T);
  rg    <- do_region(clu, as.numeric(sigd[i,3]), l=50);
  ## region2v should be renamed as l2v. The input is a list and the output is a vector.
  v1    <- region2v(rg, dat, ann, sigd[i,2]);
  v2    <- region2v(rg, dat, ann, sigd[i,11]);
  out   <- summary(glm(v1$v~ v2$v));
  out.s <- rbind(out.s, c(i.s, t.s, t.n, sigd[i,2], sigd[i,11], out$coef[2,3], out$coef[2,4]));
}

p.adjust.M <- p.adjust.methods[c(4,7)];

p.adj   <- sapply(p.adjust.M, function(meth) p.adjust(out.s[,7], meth));
out.p   <- cbind(out.s, p.adj);
out.p   <- out.p[order(as.numeric(out.p[,7])),];
colnames(out.p) <- c("sample", "tsne.pr", "tsne.dim", "gene1", "gene2", "tvalue", "P.value", "bonferroni", "fdr")
write.table(out.p, outf, quote=F, sep="\t", row.names=F);




