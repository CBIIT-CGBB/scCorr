rm(list=ls());

pdf("supp3_A.pdf", 5,5);
layout(matrix(c(1), nrow = 1, ncol =1, byrow = TRUE))
source("supp_func.R");
dat0 <- read.table("../data/01/03clust_table.txt", header=T);
d.i  <- grep("0", colnames(dat0))[1:10];
d.i  <- 2:22;
colnames(dat0)[d.i]
dat  <- dat0[, d.i];
out  <- m2table(dat);

k        <- apply(dat, 2, function(x) length(unique(x)));
k        <- as.numeric(k);
l.adj    <- 0.9;
top.n    <- max(k);
top.m    <- min(k);
lwd.from <- 1;
lwd.to   <- 1;
col.n    <- ncol(dat);
row.n    <- nrow(dat);
med.n    <- median(c(1:top.n));   # x coordinate of root, center of page

cols  <- rainbow(10, alpha=0.6);
col.l <- cols[7];

x.len <-  seq(-med.n, med.n, length.out=top.n+1);
y.len <-  seq(1, ncol(dat), length.out=top.n+1);
y.l   <-  seq(ncol(dat), 0, length.out=ncol(dat)+1);

plot(x.len, y.len, type="n", ylab="", xlab="", axes=FALSE);
fig_label('A', pos='topleft',cex=5)
x1 <- 0;
x2 <- 0;
y1 <- top.n + 1;
y2 <- top.n;
x.old <- c(1:top.n+1);
x.tmp <- c(1:top.n+1);

x.old[1] <- x2;
y.old    <- y2;
y        <- y2;
x        <- x2;

lwd <- scale.v(c(100, row.n, row.n), lwd.from, lwd.to);
lwd <- lwd * 0.3
#segments(x1, y1, x2, y2, col= col.l, lwd = lwd[2]);
dat.0 <- rep(1, row.n);

## output, out.s
## Cluster#, ClusterID, x, y, Obj# and lwd
out.s <- c(1, 1, x1, y2, row.n, lwd[2]);
## for each k

pb <- txtProgressBar(min = 0, max = length(top.n), style = 3);
for (j in 1:ncol(dat)){
  clu.n        <- dat[,j];
  names(clu.n) <- row.names(dat);
  y     <- y.l[j];
  if (j == 1){
    str <- cbind(dat.0, dat[,j]);
  } else {
    str <- cbind(dat[,j-1], dat[,j]);
  }
  str.out <- count.rows2(str);
  str.u   <- as.numeric(sort(unique(str.out[,3])));
  cols    <- rainbow(length(str.u), alpha=0.6)
  for (n in str.u){
    ## length(str.i) should be 1.
    str.i <- which(str.out[,3]==n);
    num <- 0;
    for (i in 1:length(str.i)){
      lwd <- scale.v(c(100, str.out[str.i[i],1], row.n), lwd.from, lwd.to);
      x   <- n - length(str.u)/2 - 0.5;
      segments(x.old[str.out[str.i[i],2]], y.old, x, y, col= col.l, lwd = lwd[2]);
      num <- num + str.out[str.i[i],1];
      x.tmp[str.out[str.i[i],3]] <- x;
    }
    out.s <- rbind(out.s, c(k[j], n, x, y, num, lwd[2]));
  }
  x.old <- x.tmp;
  y.old <- y;
  setTxtProgressBar(pb, j);
}
close(pb);
colnames(out.s) <- c("cluster.number", "cluster.ID", "x", "y", "number", "lwd");
points(out.s[,3], out.s[,4], pch=19, cex=log2(out.s[,5])/10, col=cols[2]);
row.names(out.s) <- c(1:nrow(out.s));
out2 <- out.s[!duplicated(out.s[,4]),];
text(out2[,3]-1.3, out2[,4], c(1,20:40), cex=0.8);
## return(list(xy=out.s, clu.table=dat));
dev.off()
