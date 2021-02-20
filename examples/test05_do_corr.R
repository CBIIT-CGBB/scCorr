rm(list=ls());

options(stringsAsFactors = F);

## cluster IDs of CD4 T cells in 50 clusters
ct1.c  <- c(6:10, 12:16, 19,20, 28:33);
ct.c   <- ct1.c;
## output directory
outd  <- "08cor_glm_CD4/";
## clusters of single cell
clu   <- read.table("03clust_table.txt", header=T);
## gene pairs from the pathways
gene  <- read.table("data/hsa04662_f.txt", header=T);
g.u   <- unique(c(gene[,1], gene[,2]));
## gene annotation
ann   <- read.table("data/gene4matrix_Seurat.txt", header=T, row.names=1);

## load data
load('./data/cd4_dat.Rdata')
load('./data/cd8_dat.Rdata')
load('./data/NK_dat.Rdata')
load('./data/other_dat.Rdata')
load('./data/b_dat.Rdata')
dat   <- dplyr::bind_cols(cd4_dat, cd8_dat, b_dat, NK_dat, other_dat)

## cluster ID
clu.n <- c(seq(40, 100, length.out = 7), seq(200, 1000, length.out = 9));

for (c.n in clu.n){
  print(c.n);
  clu.s <- paste0("clu", c.n);
  outf  <- paste0(outd, c.n, ".txt");
  clu.i <- which(clu[,23] %in% ct.c);
  ce.n  <- row.names(clu)[clu.i];
  dat.i <- which(colnames(dat) %in% ce.n);
  dat.s <- dat[,dat.i];
  sum(row.names(dat.s)==row.names(ann))==nrow(ann);

  clu.f <- clu[clu.i, clu.s];
  clu.u <- unique(clu.f);

  ann.i <- which(ann[,1] %in% g.u);
  dat.s <- dat.s[ann.i,];
  ann.s <- ann[ann.i,];

  # Get updated value for each cluster
  dat.s <- get_value(dat.s,clu.u)

  out.s <- NULL;
  for (i in 1:nrow(gene)){
    n1 <- gene[i, 1];
    n2 <- gene[i, 2];
    i1 <- which(ann.s[,1]==n1);
    i2 <- which(ann.s[,1]==n2);
    v1 <- dat.s[i1,]
    v2 <- dat.s[i2,]
    v1.v <- var(v1);
    v2.v <- var(v2);
    if (v1.v==0 | v2.v==0){
      next;
    }
    out <- summary(glm(v1~v2));
    out2  <- cor(v1, v2);
    out3  <- cor(v1, v2, method = "spearman");
    out.s <- rbind(out.s, c(n1, n2, out2, out3, out$coef[2,3], out$coef[2,4]));
  }

  p.adjust.M <- p.adjust.methods[c(4,7)];
  p.adj   <- sapply(p.adjust.M, function(meth) p.adjust(out.s[,6], meth));
  out.p   <- cbind(out.s, p.adj);
  out.p   <- out.p[order(as.numeric(out.p[,6])),];
  colnames(out.p) <- c("gene1", "gene2", "pearson.R", "spearman.R", "t.value", "Pvalue", "bonferroni", "fdr");
#  write.table(out.p, outf, sep="\t", row.names=F, quote=F);
}
