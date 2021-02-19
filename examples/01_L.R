rm(list=ls());

pdf("1_L.pdf", 20, 20);
par(mar=c(4,4,4,4));


## get angle with two points
## delta_x = touch_x - center_x
## delta_y = touch_y - center_y
## delta_x = 450 - 400
## delta_y = 450 - 400
## (theta_radians = atan2(delta_y, delta_x))
## theta_radians*180/pi

dat1 <- read.table("./data/01/03clust_table_cluID.txt", header=T);
dat2 <- read.table("./data/01/03clust_table_cluNum.txt", header=T);
dat1 <- dat1[,-c(3:11,13:21)];
dat2 <- dat2[,-c(3:11,13:21)];
dat1 <- dat1[,1:10];
dat2 <- dat2[,1:10];


num  <- seq(10, 100, length.out=10);
r0   <- seq(100, 400, length.out=10);

col0 <- rainbow(10, alpha=0.8);

plot(c(1,800), c(1,800), type="n", axes=F,xlab="", ylab="",cex.lab=1.5, cex.axis=1.5,font.main = 1);
title("Cluster Number",cex.main = 4, line = -1, font.main = 1)

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
        segments(x0, y0, x1, y1, col=col0[7], lwd=5);
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
  par(font = 2,family = 'sans')

  text(400, 400+r, paste0("", n), cex=3);

  clu.m <- max(dat1[,i]);
  cex <- NULL;
  for (j in 1:clu.m){
    k <- which(dat1[,i]==j);
    n <- sum(dat2[k,i]);
    n <- log2(n)/1.5;
    cex <- c(cex, n);
  }
  cols <- rainbow(clu.m, alpha=0.6);
  points(out$x, out$y, pch=19, col="white", cex=cex+1);
  points(out$x, out$y, pch=19, col= cols, cex=cex);
  oldx <- out$x;
  oldy <- out$y;
}
dev.off();
