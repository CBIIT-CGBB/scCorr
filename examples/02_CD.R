rm(list=ls());

pdf("2_CD.pdf", 20,10);
layout(matrix(c(1,2), nrow = 1, ncol = 2, byrow = TRUE))
par("mar"=c(7, 7, 7, 2))

cols  <- rainbow(10, alpha=0.6);

ct.c  <- c(6:10, 12:16, 19,20, 28:33); ## 28:37 CD4Tcells
clu   <- read.table("./data/01/03clust_table.txt", header=T);

load('./data/cd4_dat.Rdata')
load('./data/cd8_dat.Rdata')
load('./data/NK_dat.Rdata')
load('./data/other_dat.Rdata')
load('./data/b_dat.Rdata')

dat <- dplyr::bind_cols(cd4_dat,cd8_dat,b_dat,NK_dat,other_dat)
ann   <- read.table("./data/01/gene4matrix_Seurat.txt", header=T);

clu.i <- which(clu[,23] %in% ct.c);
clu.s <- clu[clu.i, c(23, 28)];
dat.i <- which(colnames(dat) %in% row.names(clu.s));
dat.s <- dat[,dat.i];
clu.u <- unique(clu.s[,2]);

dat1  <- read.table("./data/02/cd4_100.txt", header=T);
dat2  <- read.table("./data/02/08cor_glm_CD4.txt", header=T);
dat1  <- dat1[!duplicated(dat1[,c(1,2)]),];
dat2  <- dat2[!duplicated(dat2[,c(1,2)]),];
d1.s  <- paste0(dat1[,1], "_", dat1[,2]);
d2.s  <- paste0(dat2[,1], "_", dat2[,2]);



for (i in c(16,59)){
  g1   <- dat1[i,1];
  g2   <- dat1[i,2];
  g.s  <- paste0(g1, "_", g2);
  g2.i <- which(d2.s == g.s);  
  v1.i <- which(ann[,2]==g1)[1];
  v2.i <- which(ann[,2]==g2)[1];
  v1   <- as.numeric(dat.s[v1.i,]);
  v2   <- as.numeric(dat.s[v2.i,]);
  v1.c <- NULL;
  v2.c <- NULL;
  for (j in 1:length(clu.u)){
    c.i  <- which(clu.s[,2]==clu.u[j]);
    c.n  <- row.names(clu.s)[c.i];
    d.i  <- which(colnames(dat.s) %in% c.n);
    tmp1 <- as.numeric(dat.s[v1.i, d.i]);
    tmp2 <- as.numeric(dat.s[v2.i, d.i]);
    v1.c <- c(v1.c, mean(tmp1));
    v2.c <- c(v2.c, mean(tmp2));
  }
  main <- paste0(g1, " ", g2, "in Cluster 100")
  main <- paste0("Cluster: P value:", sprintf("%0.2E", dat1[i,8]), 
                 "\np.R:", round(dat1[i, 3], 3), " s.R:", round(dat1[i, 4], 3))
  plot(v1.c, v2.c, xlab='', ylab='', pch=19, col=cols[7], main=main,cex = 5,cex.main=3,font.main = 1,cex.lab=2, cex.axis=2);
  title(ylab=g2, line=4, cex.lab =4.5, family = "sans")
  title(xlab=g1, line=5, cex.lab =4.5, family = "sans")
  abline(lm(v2.c ~ v1.c), col=cols[1],lwd=4);

}
dev.off()

