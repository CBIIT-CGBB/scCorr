rm(list=ls());
options(stringsAsFactors = F);
library(OmicPlot)
## load data
load('./data/cd4_dat.Rdata')
load('./data/cd8_dat.Rdata')
load('./data/NK_dat.Rdata')
load('./data/other_dat.Rdata')
load('./data/b_dat.Rdata')
## merge data
dat <- dplyr::bind_cols(cd4_dat,cd8_dat,b_dat,NK_dat,other_dat)
## gene annotation
ann <- read.table("./data/01/gene4matrix_Seurat.txt", header=T);
sum(row.names(dat)==row.names(ann))==nrow(ann);

pdf("supp5_ABCD.pdf", 10,10);
layout(matrix(c(1,2,3,4), nrow = 2, ncol = 2, byrow = TRUE))
par("mar"=c(7, 7, 7, 2))


cols  <- rainbow(10, alpha=0.6);

ct.c  <- c(6:10, 12:16, 19,20, 28:33); ## 28:37 CD4Tcells
## clu100:28 clu50:23
clu   <- read.table("./data/01/03clust_table.txt", header=T);

clu.i <- which(clu[,23] %in% ct.c);
clu.s <- clu[clu.i, c(23, 28)];
dat.i <- which(colnames(dat) %in% row.names(clu.s));
dat.s <- dat[,dat.i];
clu.u <- unique(clu.s[,2]);


dat1  <- read.table("./data/supp/09cor_glm_clu_CD4/100.txt", header=T);
dat2  <- read.table("./data/supp/08cor_glm_CD4.txt", header=T);
dat1  <- dat1[!duplicated(dat1[,c(1,2)]),];
dat2  <- dat2[!duplicated(dat2[,c(1,2)]),];
d1.s  <- paste0(dat1[,1], "_", dat1[,2]);
d2.s  <- paste0(dat2[,1], "_", dat2[,2]);


for (i in 1:100){
  g1   <- dat1[i,1];
  g2   <- dat1[i,2];
  if ((g1 == 'MAPKAPK2' && g2 == 'ATF4') ||(g1 == 'FLT3LG' && g2 == 'IGF1R')){
  g.s  <- paste0(g1, "_", g2);
  g2.i <- which(d2.s == g.s);  
  v1.i <- which(ann[,2]==g1)[1];
  v2.i <- which(ann[,2]==g2)[1];
  v1   <- as.numeric(dat.s[v1.i,]);
  v2   <- as.numeric(dat.s[v2.i,]);
  main <- paste0("Single cell: P value:", sprintf("%0.2E", dat2[g2.i,8]), 
                 "\np.R:", round(dat2[g2.i, 3], 3), " s.R:", round(dat2[g2.i, 4], 3))
  plot(v1, v2, xlab=g1, ylab=g2, pch=19, col=cols[7], main=main);
  abline(lm(v2 ~ v1), col=cols[1], lwd=2);
  
  v1.m <- mean(v1);
  v1.j <- which(v1 >= v1.m);
  val.l <- NULL;
  val.l[[1]] <- v2[-v1.j];
  if (length(v1.j) < 2){
    val.l[[2]] <- rep(v2[v1.j], 2);
  } else {
    val.l[[2]] <- v2[v1.j];
  }
  vioplot4(val.l, adjust=rep(0.8, 2), at=c(1,2), col=cols[c(1,7)], label=c("Low", "High"), main="", xlab=g1, ylab=g2);
}
}
dev.off();

