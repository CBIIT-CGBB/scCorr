rm(list=ls());

pdf("supp2_AB.pdf", 15,10);
layout(matrix(c(1,2,3,4,5,6), nrow = 2, ncol = 3, byrow = TRUE))
par("mar"=c(7, 7, 7, 2))
options(stringsAsFactors = F);

source("supp_func.R");

dat <- read.table("./data/01/do_tsne30_2000.txt", header=T);
clu <- read.table("./data/01/03clust_table.txt", header=T);


# Show clusters by color
col0 <- rainbow(10, alpha=0.6);
clu.n <- c(50, 100, 1000);
for (n in clu.n){
  clu.name <- paste0("clu", n);
  clu.i    <- which(colnames(clu) %in% clu.name);
  clu.v    <- clu[,clu.i];
  clu.u    <- unique(clu.v);
  clu.j    <- length(clu.u)
  set.seed(123);
  cols  <- rainbow(clu.j, alpha=0.6);
  cols  <- sample(cols);
  main  <- paste0("cluster number:", clu.j)
  plot(dat[,c(1,2)], pch=19, col=cols[clu.v], cex=0.2, xlab="", ylab="", main='');
  title(font.main = 1,main= main, xlab="", ylab = "",pch=19, cex.main=3,cex.lab=2, cex.axis= 2.5);
  title(ylab="tSNE 2", line=4, cex.lab=2, family = "sans")
  title(xlab="tSNE 1", line=4, cex.lab=2, family = "sans")
  if (n==50){
    for (j in 1:50){
      c.i <- which(clu.v==j);
      x   <- mean(dat[c.i,1]);
      y   <- mean(dat[c.i,2]);
      shadowtext(x, y, j);
    }
  }
}


# Show clusters by circle
for (n in clu.n){
  clu.name <- paste0("clu", n);
  clu.i    <- which(colnames(clu) %in% clu.name);
  clu.v    <- clu[,clu.i];
  clu.u    <- unique(clu.v);
  clu.j    <- length(clu.u)
  set.seed(1234);
  cols  <- rainbow(clu.j, alpha=0.6);
  cols  <- sample(cols)
  out   <- mapper(dat, clu.v);

  cex <- out$coord[,3]/100;
  main <- paste0("cluster number:", clu.j)
  plot(out$coord[,1], out$coord[,2], pch=19, col=cols, cex=cex, xlab="", ylab="", main='');
  title(font.main = 1,main= main, xlab="", ylab = "",pch=19, cex.main=3,cex.lab=2, cex.axis= 2.5);
  title(ylab="tSNE 2", line=4, cex.lab=2, family = "sans")
  title(xlab="tSNE 1", line=4, cex.lab=2, family = "sans")
}
dev.off()
