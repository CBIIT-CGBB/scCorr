rm(list=ls());

pdf("supp3_BC.pdf", 16, 8);
layout(matrix(c(1,2), nrow = 1, ncol = 2, byrow = TRUE))
par(mar=c(1,1,1,1));

dat1 <- read.table("./data/01/03clust_table_cluID.txt", header=T);
dat2 <- read.table("./data/01/03clust_table_cluNum.txt", header=T);

# Plot 20 - 40 clusters
clu.n <- seq(20, 40, length.out = 21);
clu.n <- paste0("clu", clu.n);
clu.i <- which(colnames(dat1) %in% clu.n)
dat1 <- dat1[,clu.i];
dat2 <- dat2[,clu.i];


num  <- seq(20, 40, length.out=21);
r0   <- seq(100, 400, length.out=21);

col0 <- rainbow(10, alpha=0.8);


plot(c(1,800), c(1,800), type="n", axes=F, xlab="", ylab="");

## plot segments
for (i in 1:ncol(dat1)){
  n <- num[i];
  r <- r0[i];
  s.w <- 360 -   angle(400+50, 400+r, 400, 400)$degree;
  e.w <- 2*360 - angle(400-50, 400+r, 400, 400)$degree;

  out <- n2p(400, 400, r, n, start.w=s.w, end.w=e.w);

  clu.m <- max(dat1[,i]);
  if (i > 1){
    for (clu.i in 1:clu.m){
      j.i  <- which(dat1[,i]==clu.i);
      i1.i <- i - 1;
      p.c  <- dat1[j.i, i1.i];
      p.c  <- unique(p.c);
      for (p.i in p.c){
        x1 <- out$x[clu.i];
        y1 <- out$y[clu.i];
        x0 <- oldx[p.i];
        y0 <- oldy[p.i];
        segments(x0, y0, x1, y1, col=col0[7], lwd=0.2);
      }
    }
  }
  oldx <- out$x;
  oldy <- out$y;
}

## plot points
for (i in 1:ncol(dat1)){
  n <- num[i];
  r <- r0[i];
  s.w <- 360 -   angle(400+50, 400+r, 400, 400)$degree;
  e.w <- 2*360 - angle(400-50, 400+r, 400, 400)$degree;

  out <- n2p(400, 400, r, n, start.w=s.w, end.w=e.w);
  text(400, 825, "Cluster Number");
  text(400, 400+r, paste0("", n), cex=0.9);

  clu.m <- max(dat1[,i]);
  cex <- NULL;
  for (j in 1:clu.m){
    k <- which(dat1[,i]==j);
    n <- sum(dat2[k,i]);
    n <- log2(n)/6;
    cex <- c(cex, n);
  }
  cols <- rainbow(clu.m, alpha=0.6);
  points(out$x, out$y, pch=19, col="white", cex=cex+0.1);
  points(out$x, out$y, pch=19, col=cols, cex=cex);
  oldx <- out$x;
  oldy <- out$y;
}




# Plot clusters 100 -1000
dat1  <- read.table("./data/01/03clust_table_cluID.txt", header=T);
dat2  <- read.table("./data/01/03clust_table_cluNum.txt", header=T);
clu.n <- seq(100, 1000, length.out = 10);
clu.n <- paste0("clu", clu.n);
clu.i <- which(colnames(dat1) %in% clu.n)
dat1 <- dat1[,clu.i];
dat2 <- dat2[,clu.i];


num  <- seq(100, 1000, length.out=10);
r0   <- seq(100, 400, length.out=10);

col0 <- rainbow(10, alpha=0.8);
plot(c(1,800), c(1,800), type="n", axes=F, xlab="", ylab="");

## plot segments
for (i in 1:ncol(dat1)){
  n <- num[i];
  r <- r0[i];
  s.w <- 360 -   angle(400+50, 400+r, 400, 400)$degree;
  e.w <- 2*360 - angle(400-50, 400+r, 400, 400)$degree;

  out <- n2p(400, 400, r, n, start.w=s.w, end.w=e.w);

  clu.m <- max(dat1[,i]);
  if (i > 1){
    for (clu.i in 1:clu.m){
      j.i  <- which(dat1[,i]==clu.i);
      i1.i <- i - 1;
      p.c  <- dat1[j.i, i1.i];
      p.c  <- unique(p.c);
      for (p.i in p.c){
        x1 <- out$x[clu.i];
        y1 <- out$y[clu.i];
        x0 <- oldx[p.i];
        y0 <- oldy[p.i];
        segments(x0, y0, x1, y1, col=col0[7], lwd=0.2);
      }
    }
  }
  oldx <- out$x;
  oldy <- out$y;
}

## plot points
for (i in 1:ncol(dat1)){
  n <- num[i];
  r <- r0[i];
  s.w <- 360 -   angle(400+50, 400+r, 400, 400)$degree;
  e.w <- 2*360 - angle(400-50, 400+r, 400, 400)$degree;

  out <- n2p(400, 400, r, n, start.w=s.w, end.w=e.w);
  text(400, 825, "Cluster Number");
  text(400, 400+r, paste0("", n), cex=0.9);

  clu.m <- max(dat1[,i]);
  cex <- NULL;
  for (j in 1:clu.m){
    k <- which(dat1[,i]==j);
    n <- sum(dat2[k,i]);
    n <- log2(n)/30;
    cex <- c(cex, n);
  }
  cols <- rainbow(clu.m, alpha=0.6);
  points(out$x, out$y, pch=19, col="white", cex=cex+0.1);
  points(out$x, out$y, pch=19, col=cols, cex=cex);
  oldx <- out$x;
  oldy <- out$y;
}

dev.off();
